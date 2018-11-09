//If character wants to attack!
if (attackKey && attacking == false)
{
    attacking = true;
    image_index = 0;
}

//Do attack!
if(attacking)
{
    //"Claw" Powerup
    if(playerpowerup == 1) 
    {
        image_speed = 0.45;
        if(createhitbox == true && image_index >= 5)
        {
            createhitbox = false;
            var xx = x;
            var yy = y;
            
            if (dir = "right")
            {
                xx = x + 40;
            }
            else
            {
                xx = x - 40;
            }
            
            
            var proj = instance_create(xx, yy, obj_projectile);
            proj.speed = 0;
            proj.owner = global.playerId;
            proj.projectileId = projectileCount;
            
            buffer_seek(global.buffer, buffer_seek_start, 0);
            buffer_write(global.buffer, buffer_u8, 11);
            buffer_write(global.buffer, buffer_u32, global.playerId);
            buffer_write(global.buffer, buffer_u32, projectileCount);
            buffer_write(global.buffer, buffer_f32, xx);
            buffer_write(global.buffer, buffer_f32, yy);
            buffer_write(global.buffer, buffer_u8, global.playerRoom);
            network_send_packet(obj_controller.socket, global.buffer, scr_getBufferSize());
            
            projectileCount++;
            
            //Speed up ending of animation
            image_speed = 0.45;
            
            
        }
        switch(colour)
        {
            case 0:
                sprite_index = spr_PlayerBlueSlash
            break
            
            case 1:
                sprite_index = spr_PlayerRedSlash
            break
            
            case 2:
                sprite_index = spr_PlayerGreenSlash
            break
            
            case 3:
                sprite_index = spr_PlayerYellowSlash
            break
        }
        
        //Play sound once
        if(attacksound == true)
        {
            var slash = audio_play_sound(Slash_1, 0, false);
            attacksound = false;
            soundpitch = choose (1,2,3,4,5);
            switch (soundpitch)
            {
                case 1: audio_sound_pitch(slash, 1.2); break;
                case 2: audio_sound_pitch(slash, 1.1); break;
                case 3: audio_sound_pitch(slash, 1.0); break;
                case 4: audio_sound_pitch(slash, 0.9); break;
                case 5: audio_sound_pitch(slash, 0.8); break;
            }
            
        }
        
        //Turn off attack
        if(image_index >= 8)
        {
            attacking = false;
            attacksound = true;
            createhitbox = true;
        }
    }
}