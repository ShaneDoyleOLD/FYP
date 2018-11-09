//If character is jumping
if (jumping)
{
    //If we aren't touching ground
    if (vspd < 0)
    {
        jumping = true;
    }
    //Falling
    else
    {
        jumping = false;
        falling = true;
    }
}