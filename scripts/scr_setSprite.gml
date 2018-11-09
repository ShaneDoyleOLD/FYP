///Set Sprites
if(!attacking)
{
    if (jumping)
    {
        if(colour == 0)
        {
            sprite_index = spr_PlayerBlueJump;
        }
        else if(colour == 1)
        {
            sprite_index = spr_PlayerRedJump;
        }
        else if(colour == 2)
        {
            sprite_index = spr_PlayerGreenJump;
        }
        else if(colour == 3)
        {
            sprite_index = spr_PlayerYellowJump;
        }
        
        image_speed = 0.05;
    }

    else if (falling)
    {
        if(colour == 0)
        {
            sprite_index = spr_PlayerBlueJump;
        }
        else if(colour == 1)
        {
            sprite_index = spr_PlayerRedJump;
        }
        else if(colour == 2)
        {
            sprite_index = spr_PlayerGreenJump;
        }
        else if(colour == 3)
        {
            sprite_index = spr_PlayerYellowJump;
        }
        image_index = 2;
        image_speed = 0;
    }
    
    else if (!jumping && !falling)
    {
        switch(state)
        {
            case "standing":
                if(colour == 0)
                {
                    sprite_index = spr_PlayerBlueIdle;
                }
                else if(colour == 1)
                {
                    sprite_index = spr_PlayerRedIdle;
                }
                else if(colour == 2)
                {
                    sprite_index = spr_PlayerGreenIdle;
                }
                else if(colour == 3)
                {
                    sprite_index = spr_PlayerYellowIdle;
                }
                image_speed = 0.3;
            break;
            
            case "walking":
                if(colour == 0)
                {
                    sprite_index = spr_PlayerBlueRun;
                }
                else if(colour == 1)
                {
                    sprite_index = spr_PlayerRedRun;
                }
                else if(colour == 2)
                {
                    sprite_index = spr_PlayerGreenRun;
                }
                else if(colour == 3)
                {
                    sprite_index = spr_PlayerYellowRun;
                }
                image_speed = 0.20;
            break;
            
            case "running":
                if(colour == 0)
                {
                    sprite_index = spr_PlayerBlueRun;
                }
                else if(colour == 1)
                {
                    sprite_index = spr_PlayerRedRun;
                }
                else if(colour == 2)
                {
                    sprite_index = spr_PlayerGreenRun;
                }
                else if(colour == 3)
                {
                    sprite_index = spr_PlayerYellowRun;
                }
                
                switch(dir)
                {
                    case "right":
                        image_speed = 0.20 * hspd;
                    break;
                    
                    case "left":
                        image_speed = -0.20 * hspd;
                    break;
                }
            break;
                
            
            case "ducking":                
                if(colour == 0)
                {
                    sprite_index = spr_PlayerBlueIdle;
                }
                else if(colour == 1)
                {
                    sprite_index = spr_PlayerRedIdle;
                }
                else if(colour == 2)
                {
                    sprite_index = spr_PlayerGreenIdle;
                }
                else if(colour == 3)
                {
                    sprite_index = spr_PlayerYellowIdle;
                }
            break;
            
            case "throwing":
                sprite_index = spr_PlayerBlueIdle;
                image_speed = 0.2;
            break;
        }
    }
}
    
switch (dir)
{
    case "left":
        image_xscale = -1;
    break;
    
    case "right":
        image_xscale = 1;
    break;
}