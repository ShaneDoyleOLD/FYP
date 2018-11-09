if(inverted > 0)
{
    if (place_meeting(x, y + inverted, obj_block) && death == false)
    {
        //If touching ground
        vspd = 0;
    
    
    
        jumping = false;
        falling = false;
        
        //If jumping
        if (jumpKey)
        {
            jumping = true;
            vspd = -jspd;
        }
    }
    //If in air
    else
    {
        if (inverted == 1)
        {
            if (vspd < terminalVelocity)
            {
                vspd += grav;
            }
        }
        
        else if (inverted == -1)
        {
            if(vspd > terminalVelocity)
            {
                vspd += grav;
            }
        }
        
        else if(xinverted == 1)
        {
            hspd -= grav;
        }
        
        if (sign(vspd) == 1)
        {
            falling = true;
        }
    }
}
else if (xinverted > 0)
{
    if (place_meeting(x - 1, y, obj_block) && death == false)
    {
        //If touching ground
        vspd = 0;
    
    
        jumping = false;
        falling = false;
        
        //If jumping
        if (jumpKey)
        {
            jumping = true;
            hspd = jspd;
        }
    }
    //If in air
    else
    {
        if (inverted == 1)
        {
            if (vspd < terminalVelocity)
            {
                vspd += grav;
            }
        }
        
        else if (inverted == -1)
        {
            if(vspd > terminalVelocity)
            {
                vspd += grav;
            }
        }
        
        else if(xinverted == 1)
        {
            hspd -= grav;
        }
        
        if (sign(vspd) == 1)
        {
            falling = true;
        }
    }
}