var buffer = argument[0];
var socket = argument[1];
var msgId = buffer_read(buffer, buffer_u8); //This will be used in the following cases below

switch (msgId)
{
    //Latency Request
    case 1:
        var time = buffer_read(buffer, buffer_u32)       //Read in the time from the client
        buffer_seek(global.buffer, buffer_seek_start, 0);//Seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 1);       //Write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u32, time);   //Write the time receieved the the global write buffer
        
        //Send back to player who sent this message
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    //Register request
    case 2:
        var playerUsername = buffer_read(buffer, buffer_string);
        var passwordHash = buffer_read(buffer, buffer_string);
        var response = 0;
        
        //Check if player hasn't already registered
        if (!file_exists(playerUsername + ".ini"))
        {
            //Register a new player
            ini_open(playerUsername + ".ini");
            ini_write_string("credentials", "username", playerUsername);
            ini_write_string("credentials", "password", passwordHash);
            ini_write_real("position", "room", 1);
            ini_write_real("position", "x", 224);
            ini_write_real("position", "y", 160);
            ini_close();
            
            response = 1;
        }
        
        //Send response to the client
        buffer_seek(global.buffer, buffer_seek_start, 0);
        buffer_write(global.buffer, buffer_u8, 2);       //Write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u8, response);
        buffer_write(global.buffer, buffer_u32, 224);
        buffer_write(global.buffer, buffer_u32, 160);
        buffer_write(global.buffer, buffer_u8, 1);
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    //Login request
    case 3:
        var pId = buffer_read(buffer, buffer_u32);
        var playerUsername = buffer_read(buffer, buffer_string);
        var passwordHash = buffer_read(buffer, buffer_string);
        var response = 0;
        var positionX = 224;
        var positionY = 160;
        var currentRoom = 0;
        
        ini_open(playerUsername + ".ini");
        var playerStoredPassword = ini_read_string("credentials", "password", "");
        positionX = ini_read_real("position", "x", 0);
        positionY = ini_read_real("position", "y", 0);
        currentRoom = ini_read_real("position", "room", 0);
        ini_close();
        
        response = 1;
        
        with (obj_server_player)
        {
                playerName = playerUsername;
        }
        
        
        //Send Response
        buffer_seek(global.buffer, buffer_seek_start, 0);   //Seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 3);          //Write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u8, response);
        buffer_write(global.buffer, buffer_u32, positionX);
        buffer_write(global.buffer, buffer_u32, positionY);
        buffer_write(global.buffer, buffer_u8, currentRoom);
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    //Change player room request
    case 6:
        var pId = buffer_read(buffer, buffer_u32);
        var type = buffer_read(buffer, buffer_u8);
        var pX = buffer_read(buffer, buffer_u32);
        var pY = buffer_read(buffer, buffer_u32);
        var roomId = buffer_read(buffer, buffer_u8);
        var pName = "";
        
        with (obj_server_player)
        {
            if (playerIdentifier == pId)
            {
                if (roomId == 0)
                {
                    playerInGame = false;
                }
                else
                {
                    playerInGame = true;
                }
                pName = playerName;
                playerType = type;
                playerX = pX;
                playerY = pY;
                playerRoom = roomId;
            }
        }
        
        //Tell other players in the same room about a room change
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket)
            {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 6);
                buffer_write(global.buffer, buffer_u32, pId);
                buffer_write(global.buffer, buffer_u8, type);
                buffer_write(global.buffer, buffer_string, pName);
                buffer_write(global.buffer, buffer_u32, pX);
                buffer_write(global.buffer, buffer_u32, pY);
                buffer_write(global.buffer, buffer_u8, roomId);
                network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
            }
        }
        
        //If the player is going to a room
        if (roomId != 0)
        {
            //Tell this player about other players in the same room
            for (var i = 0; i < ds_list_size(global.players);i++)
            {
                var storedPlayerSocket = ds_list_find_value(global.players, i);
                
                if (storedPlayerSocket != socket)
                {
                    var player = noone;
                    
                    with (obj_server_player)
                    {
                        if (self.playerSocket == storedPlayerSocket)
                        {
                            player = id;
                        }
                    }
                    
                    if (player != noone)
                    {
                        if (player.playerInGame && player.playerRoom == roomId)
                        {
                            buffer_seek(global.buffer, buffer_seek_start, 0);
                            buffer_write(global.buffer, buffer_u8, 6);
                            buffer_write(global.buffer, buffer_u32, player.playerIdentifier);
                            buffer_write(global.buffer, buffer_u8, player.playerType);
                            buffer_write(global.buffer, buffer_string, player.playerName);
                            buffer_write(global.buffer, buffer_u32, player.playerX);
                            buffer_write(global.buffer, buffer_u32, player.playerY);
                            buffer_write(global.buffer, buffer_u8, player.playerRoom);
                            network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                        }
                    }
                }
            }
            
            //Tell this player about active NPCs
            for (var i = 0; i < instance_number(obj_server_npc); i++)
            {
                var npc = instance_find(obj_server_npc, i);
                
                if (npc.npcRoom == roomId)
                {
                    buffer_seek(global.buffer, buffer_seek_start, 0);
                    buffer_write(global.buffer, buffer_u8, 9);
                    buffer_write(global.buffer, buffer_u32, npc.npcId);
                    buffer_write(global.buffer, buffer_f32, npc.xx);
                    buffer_write(global.buffer, buffer_f32, npc.yy);
                    buffer_write(global.buffer, buffer_u8, npc.npcType);
                    network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                }
            }
            
            //Tell this player about existing projectiles
            for (var i = 0; i < instance_number(obj_server_projectile); i++)
            {
                var projectile = instance_find(obj_server_projectile, i);
                
                if (projectile.projectileRoom == roomId)
                {
                    buffer_seek(global.buffer, buffer_seek_start, 0);
                    buffer_write(global.buffer, buffer_u8, 11);
                    buffer_write(global.buffer, buffer_u32, projectile.owner);
                    buffer_write(global.buffer, buffer_u32, projectile.projectileId);
                    buffer_write(global.buffer, buffer_f32, projectile.x);
                    buffer_write(global.buffer, buffer_f32, projectile.y);
                    network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
                }
            }
            
            //Tell this player about existing blocks!
            for (var i = 0; i < instance_number(obj_block); i++)
            {
                var block = instance_find(obj_block, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 13);
                buffer_write(global.buffer, buffer_s32, block.x);
                buffer_write(global.buffer, buffer_s32, block.y);
                buffer_write(global.buffer, buffer_s8, block.image_index);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                
            }
            
            //Tell this player about existing bush!
            for (var i = 0; i < instance_number(obj_bush1); i++)
            {
                var bush1 = instance_find(obj_bush1, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 14);
                buffer_write(global.buffer, buffer_s32, bush1.x);
                buffer_write(global.buffer, buffer_s32, bush1.y);
                buffer_write(global.buffer, buffer_s16, bush1.image_angle);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                
            }
            
            //Tell this player about existing grass!
            for (var i = 0; i < instance_number(obj_grass1); i++)
            {
                var grass1 = instance_find(obj_grass1, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 15);
                buffer_write(global.buffer, buffer_s32, grass1.x);
                buffer_write(global.buffer, buffer_s32, grass1.y);
                buffer_write(global.buffer, buffer_s16, grass1.image_angle);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                
            }
            
            //Tell this player about existing right portals!
            for (var i = 0; i < instance_number(obj_RightPortal); i++)
            {
                var rightportal = instance_find(obj_RightPortal, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 16);
                buffer_write(global.buffer, buffer_s32, rightportal.x);
                buffer_write(global.buffer, buffer_s32, rightportal.y);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
            
            //Tell this player about existing up portals!
            for (var i = 0; i < instance_number(obj_Portal); i++)
            {
                var upportal = instance_find(obj_Portal, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 17);
                buffer_write(global.buffer, buffer_s32, upportal.x);
                buffer_write(global.buffer, buffer_s32, upportal.y);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
            
            //Tell this player about existing left portals!
            for (var i = 0; i < instance_number(obj_LeftPortal); i++)
            {
                var leftportal = instance_find(obj_LeftPortal, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 18);
                buffer_write(global.buffer, buffer_s32, leftportal.x);
                buffer_write(global.buffer, buffer_s32, leftportal.y);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
            
            //Tell this player about existing down portals!
            for (var i = 0; i < instance_number(obj_DownPortal); i++)
            {
                var downportal = instance_find(obj_DownPortal, i);
                
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 19);
                buffer_write(global.buffer, buffer_s32, downportal.x);
                buffer_write(global.buffer, buffer_s32, downportal.y);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
            
            
            //Save this room change
            ini_open(pName + ".ini");
            ini_write_real("position", "room", roomId);
            ini_write_real("position", "x", pX);
            ini_write_real("position", "y", pY);
            ini_close();
        }
        else
        {
            //Save their last known position
            ini_open(pName + ".ini");
            ini_write_real("position", "room", roomId);
            ini_write_real("position", "x", pX);
            ini_write_real("position", "y", pY);
            ini_close();
        }
    break;
    
    //PROBABLY MOST IMPORTANT CASE!
    //Player information requests
    case 7:
        var pId = buffer_read(buffer, buffer_u32);
        var xx = buffer_read(buffer, buffer_f32);
        var yy = buffer_read(buffer, buffer_f32);
        var acc = buffer_read(buffer, buffer_f32);
        var vacc = buffer_read(buffer, buffer_f32);
        //var imageIndex = buffer_read(buffer, buffer_u8);
        var dir = buffer_read(buffer, buffer_s8);
        var imageangle = buffer_read(buffer, buffer_s16);
        var sprite_number = buffer_read(buffer, buffer_s16);
        var image_frame = buffer_read(buffer, buffer_s16);
        var hp = buffer_read(buffer, buffer_u8);
        var attacking = buffer_read(buffer, buffer_bool);
        var roomId = buffer_read(buffer, buffer_u8);
    
        
        //Tell other players about this change
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket)
            {
                var player = noone;
                
                with (obj_server_player)
                {
                    if (playerIdentifier == pId)
                    {
                        player = id;
                        playerX = xx;
                        playerY = yy;
                    }
                }
                
                if (player != noone)
                {
                    if (player.playerInGame && player.playerRoom == roomId)
                    {
                        buffer_seek(global.buffer, buffer_seek_start, 0);
                        buffer_write(global.buffer, buffer_u8, 7);
                        buffer_write(global.buffer, buffer_u32, pId);
                        buffer_write(global.buffer, buffer_f32, xx);
                        buffer_write(global.buffer, buffer_f32, yy);
                        buffer_write(global.buffer, buffer_f32, acc);
                        buffer_write(global.buffer, buffer_f32, vacc);
                        buffer_write(global.buffer, buffer_s8, dir);
                        buffer_write(global.buffer, buffer_s16, imageangle);
                        buffer_write(global.buffer, buffer_s16, sprite_number);
                        buffer_write(global.buffer, buffer_s16, image_frame);
                        buffer_write(global.buffer, buffer_u8, hp);
                        buffer_write(global.buffer, buffer_bool, attacking);
                        network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
                    }
                }
                
                
            }
        }
    break;
    
    //Chat request (unused)
    case 8:
        var pId = buffer_read(buffer, buffer_u32);
        var text = buffer_read(buffer, buffer_string);
        var roomId = buffer_read(buffer, buffer_u8);
        
        //Tell other players about this change
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket)
            {
                var player = noone;
                
                with (obj_server_player)
                {
                    if (self.playerSocket == storedPlayerSocket)
                    {
                        player = id;
                    }
                }
                
                if (player != noone)
                {
                    if (player.playerInGame && player.playerRoom == roomId)
                    {
                        buffer_seek(global.buffer, buffer_seek_start, 0);
                        buffer_write(global.buffer, buffer_u8, 8);
                        buffer_write(global.buffer, buffer_u32, pId);
                        buffer_write(global.buffer, buffer_string, text);
                        network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
                    }
                }
            }
        }
    break;
    
    //Update latency response
    case 10:
        var latency = buffer_read(buffer, buffer_u32);
        var player = noone;
        
        with (obj_server_player)
        {
            if (self.playerSocket == socket)
            {
                player = id;
            }
        }
        
        if (player != noone)
        {
            player.playerLatency = latency;
        }
        
        //Tell other players about this change
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket)// don't send a packet to the client we got this requst from
            {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 10);
                buffer_write(global.buffer, buffer_u32, player.playerIdentifier);
                buffer_write(global.buffer, buffer_u32, player.playerLatency);
                network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
            }
        }
    break;
    
    //Creation of projectile / hitboxes
    case 11:
        var pId = buffer_read(buffer, buffer_u32);
        var projectileId = buffer_read(buffer, buffer_u32);
        var xx = buffer_read(buffer, buffer_f32);
        var yy = buffer_read(buffer, buffer_f32);
        var sprite_number = buffer_read(buffer, buffer_u16);
        var xdir = buffer_read(buffer, buffer_s8);
        var ydir = buffer_read(buffer, buffer_s8);
        var powerup = buffer_read(buffer, buffer_u8);
        var life = buffer_read(buffer, buffer_u8);
        var roomId = buffer_read(buffer, buffer_u8);
        
        var projectile = noone;
        
        with (obj_server_projectile)
        {
            if (self.owner == pId && self.projectileId == projectileId)
            {
                projectile = id;
            }
        }
        
        if (projectile != noone)
        {
            projectile.x = xx;
            projectile.y = yy;
            projectile.sprite_index = sprite_number;
            projectile.life = life;
        }
        else
        {
            var p = instance_create(xx, yy, obj_server_projectile);
            p.owner = pId;
            p.projectileId = projectileId;
            p.sprite_index = sprite_number;
            p.image_xscale = xdir;
            p.image_yscale = ydir;
            p.powerup = powerup;
        }
        
        //Send data to other clients about new update
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
        
            if (storedPlayerSocket != socket) //Don't send packet to client who sent request
            {
                var player = noone;
                
                with (obj_server_player)
                {
                    if (self.playerSocket == storedPlayerSocket)
                    {
                        player = id;
                    }
                    
                    if (player != noone)
                    {
                        if (player.playerInGame && player.playerRoom == roomId)
                        {
                            buffer_seek(global.buffer, buffer_seek_start, 0);
                            buffer_write(global.buffer, buffer_u8, 11);
                            buffer_write(global.buffer, buffer_u32, pId);
                            buffer_write(global.buffer, buffer_u32, projectileId);
                            buffer_write(global.buffer, buffer_f32, xx);
                            buffer_write(global.buffer, buffer_f32, yy);
                            buffer_write(global.buffer, buffer_u16, sprite_number);
                            buffer_write(global.buffer, buffer_s8, xdir);
                            buffer_write(global.buffer, buffer_s8, ydir);
                            buffer_write(global.buffer, buffer_u8, powerup);
                            buffer_write(global.buffer, buffer_u8, life);
                            network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
                        }
                    }
                }
            }
        }
    break;
    
    //Destroy projectile response
    case 12:
        var pId = buffer_read(buffer, buffer_u32);
        var projectileId = buffer_read(buffer, buffer_u32);
        var roomId = buffer_read(buffer, buffer_u8);
        
        with (obj_server_projectile)
        {
            if (self.owner == pId && self.projectileId == projectileId)
            {
                instance_destroy();
            }
        }
        
        //Tell other players about this change
        for (var i = 0; i < ds_list_size(global.players);i++)
        {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
        
            if (storedPlayerSocket != socket) //Don't send packet to client who sent request
            {
                var player = noone;
                
                with (obj_server_player)
                {
                    if (self.playerSocket == storedPlayerSocket)
                    {
                        player = id;
                    }
                    
                    if (player != noone)
                    {
                        if (player.playerInGame && player.playerRoom == roomId)
                        {
                            buffer_seek(global.buffer, buffer_seek_start, 0);
                            buffer_write(global.buffer, buffer_u8, 12);
                            buffer_write(global.buffer, buffer_u32, pId);
                            buffer_write(global.buffer, buffer_u32, projectileId);
                            network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
                        }
                    }
                }
            }
        }
    break;
}
