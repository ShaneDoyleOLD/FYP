//Horizontal collision
if(inverted > 0)
{
if(death == false)
{
    if (place_meeting(x+hspd, y, obj_block))
    {
        while (!place_meeting(x+sign(hspd), y, obj_block))
        {
            x += sign(hspd);
        }
        
        if(death == false)
        {
        hspd = 0;
       }
    }
}

//Set horizontal position
x += hspd;

//Vertical collisions
if(death == false)
{
    if (place_meeting(x, y+vspd, obj_block))
    {
        while (!place_meeting(x, y+sign(vspd), obj_block))
        {
            y += sign(vspd);
        }
        
        vspd = 0;
    }
}

//Set vertical position
y += vspd;
}







else if (xinverted > 0)
{
if(death == false)
{
    if (place_meeting(x+vspd, y, obj_block))
    {
        while (!place_meeting(x+sign(vspd), y, obj_block))
        {
            x += sign(vspd);
        }
        
        if(death == false)
        {
        vspd = 0;
       }
    }
}

//Set horizontal position
x += hspd;

//Vertical collisions
if(death == false)
{
    if (place_meeting(x, y+hspd, obj_block))
    {
        while (!place_meeting(x, y+sign(hspd), obj_block))
        {
            y += sign(hspd);
        }
        
        hspd = 0;
    }
}

//Set vertical position
y += vspd;
}