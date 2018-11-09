//Move right
if (rightKey && !leftKey && death == false)
{
    if(inverted > 0)
    {
        dir = "right";
        if(attacking == false)
        {
            state = "running";
        }
        
        hspd += runningAcc;
        if(hspd > runningMaxSpd)
        {
            hspd = runningMaxSpd;
        }
    }
    else if (xinverted > 0)
    {
        dir = "right";
        if(attacking == false)
        {
            state = "running";
        }
        
        vspd += runningAcc;
        if(vspd > runningMaxSpd)
        {
            //vspd = runningMaxSpd;
        }
    }
}