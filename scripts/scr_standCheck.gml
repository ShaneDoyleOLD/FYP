//If standing still...
if ((!leftKey && !rightKey) || (leftKey && rightKey)) && (!jumping && !falling)
{ 
    if(inverted > 0)
    {
        if (state != "throwing")
        {
            if (duckKey)
            {
                state = "ducking";
            }
            
            else
            {
                if(hspd == 0)
                {
                    state = "standing";
                }
                else
                {
                    state = "running";
                }
            }
        }
        
        //Deaccelerate
        if (dir == "left")
        {
            if (hspd < 0)
            {
                hspd += fric;
            }
            else
            {
                hspd = 0;
            }
        }
        
        if (dir == "right")
        {
            if (hspd > 0)
            {
                hspd -= fric;
            }
            else
            {
                hspd = 0;
            }
        }
    }
}