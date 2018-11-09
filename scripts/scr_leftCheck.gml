//Move left
if (leftKey && !rightKey && death == false)
{
    if(inverted > 0)
    {
        dir = "left";
        if(attacking == false)
        {
            state = "running";
        }
        
        hspd -= runningAcc;
        if(hspd < (runningMaxSpd*-1))
        {
            hspd = (runningMaxSpd*-1);
        }
    }
    else if (xinverted > 0)
    {
        dir = "left";
        if(attacking == false)
        {
            state = "running";
        }
        
        vspd -= runningAcc;
        if(vspd < (runningMaxSpd*-1))
        {
           // vspd = (runningMaxSpd*-1);
        }
    }
}