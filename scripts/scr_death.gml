if (death)
{
    //Different colours
    if(colour == 0)
    {
        sprite_index = spr_PlayerBlueDeath;
    }
    else if(colour == 1)
    {
        sprite_index = spr_PlayerRedDeath;
    }
    else if(colour == 2)
    {
        sprite_index = spr_PlayerGreenDeath;
    }
    else if(colour == 3)
    {
        sprite_index = spr_PlayerYellowDeath;
    }
     
    //Ensure that animation stops correctly
    if(image_index >= 3 )
    {
        image_index = 3;
        image_speed = 0;
    }
    else
    {
        image_speed = 0.15;
    }

    //hspd = lerp(hspd, 0, 0.0333);
    //Spin animation.
    if(hspd > 0)
    {
        image_angle += 12.5;
    }
    else
    {
        image_angle -= 12.5;
    }
}