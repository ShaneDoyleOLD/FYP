//Generation Variables
randomize();
top = 32 * 0 //Top limit of blocks
bottom = 32 * 80; //Bottom limit of block (Don't change this under room_height - 32)

startingx = 32 * 20; //Where we want to start generation on X, usually 0.
startingy = 32 * choose(22,23,24,25,26); //Where we want to start on Y.

currentx = startingx; //Adjusted throughout generation
currenty = startingy; //Adjusted throughout generation

altitude1 = 2  //How often we want the game to try switch a height
altitude2 = 4;
altitude3 = 4;
altitude = choose(4);
altitudechance = 80 //% chance of the height changing. Lower would be more flat lands.

//Flora objects
bush = 0;
bushchance = choose(10,12,12,14,8);

grasschance = 65; //Percentage of a block having grass
spawngrass = true; //If true, will ALWAYS spawn grass, regardless of percentage

//Size of world.
blocksize = choose(26,28,30,32,34,36);

//Pitfalls
pitfall = 0;
pitfallchance = choose(46,50,54);

//Used in loops, don't touch.
altitudecheck = 0;


instance_create(startingx + 16, startingy - 96, obj_Portal);
instance_create(startingx - 96, startingy + 16, obj_LeftPortal);

//Up 
for(i=0; i<blocksize; i++)
{
    altitudecheck++;
    bush++;
    pitfall++;
    grasschance = 65;
    
    //Check to do pitfall or not.
    if(pitfall == pitfallchance && i < room_width*0.70)
    {
        currentx += 32 * choose(2,3,4);
        pitfall = 0;
        bush -= 4;
    }
    
    //Spawn bush
    if(bush == bushchance)
    {
        bush = 0;
        bushchance = choose(8,10,12,14,8);
        instance_create(currentx,currenty-32,obj_bush1);
    }
    
    //Spawn grass
    grasstemp = irandom_range(1,100);
    if(grasschance >= grasstemp || spawngrass == true)
    {
        instance_create(currentx,currenty,obj_grass1);
        
        //Ensure 2 patches spawn
        if(spawngrass == true)
        {
            spawngrass = false;
        }
        else
        {
            spawngrass = true;
        }
    }
    
    var block = instance_create(currentx, currenty, obj_block);
    
    //Left corner
    if(i == 0)
    {
        block.image_index = 2;
    }
    //Right corner
    else if(i == blocksize - 1)
    {
        block.image_index = 3;
    }
    /*
    for(j=0; j<0; j++)
    {
        instance_create(currentx, currenty+(32*j), obj_block);
    }*/
    
    //Height changer.
    if(i < blocksize - 2)
    {
        if(altitudecheck >= altitude)
        {
            altitude = choose(altitude1, altitude2, altitude3);
            temp = random_range(0,100)
            
            //Use our % change to make
            if(altitudechance >= temp)
            {
                temp2 = choose(32,-32);
                currenty += temp2;
            }
            
            //Reset checker
            altitudecheck = 0
        }
    }
    
    //Next column.
    currentx += 32;
    
    //Ensure we don't generate under room.
    if(currenty >= bottom)
    {
        /*
        temp = random_range(0,100)
        if(altitudechance >= temp)
        {
            currenty -= 32;
        }
        else
        {
            currenty = currenty;
        }*/
        currenty -= 32;
        
    }
    
    //Log final coords of the up ground
    global.up_currentx = currentx;
    global.up_currenty = currenty;
    
    //Ensure we don't generate under room.
    if(currenty < top)
    {
        currenty = top - 32;
    }
}

instance_create(global.up_currentx, global.up_currenty+16, obj_RightPortal);
instance_create(global.up_currentx-48, global.up_currenty-(32*4), obj_Portal);


//Right
currentx -= 32;
currenty += 32;
altitude1 = 2  //How often we want the game to try switch a height
altitude2 = 4;
altitude3 = 4;
altitudecheck = 0;
altitude = choose(4);
spawngrass = true

for(i=0; i<blocksize; i++)
{
    altitudecheck++;
    bush++;
    pitfall++;
    grasschance = 65;
    
    var block = instance_create(currentx, currenty, obj_block);
    block.image_index = 7;
    
    //Spawn bush
    if(bush == bushchance)
    {
        bush = 0;
        bushchance = choose(8,10,12,14,8);
        var obj_bush = instance_create(currentx+64,currenty,obj_bush1);
        obj_bush.image_angle = -90;
    }
    
    //Spawn grass
    grasstemp = irandom_range(1,100);
    if(grasschance >= grasstemp || spawngrass == true)
    {
        var obj_grass = instance_create(currentx + 32,currenty,obj_grass1);
        obj_grass.image_angle = -90;
        
        //Ensure 2 patches spawn
        if(spawngrass == true)
        {
            spawngrass = false;
        }
        else
        {
            spawngrass = true;
        }
    }
    
    //Height changer.
    if(i < blocksize - 2)
    {
        if(altitudecheck >= altitude)
        {
            altitude = choose(altitude1, altitude2, altitude3);
            temp = random_range(0,100)
            
            //Use our % change to make
            if(altitudechance >= temp)
            {
                temp2 = choose(32,-32);
                currentx += temp2;
            }
            
            //Reset checker
            altitudecheck = 0
        }
    }
    
    global.right_currentx = currentx;
    global.right_currenty = currenty;
    
    
    //Next row.
    currenty += 32;
}

//Create portals for right corner
instance_create(global.right_currentx + 32, global.right_currenty + 16, obj_RightPortal);
instance_create(global.right_currentx - 16, global.right_currenty + 32, obj_DownPortal);



//Left
currentx = startingx;
currenty = startingy + 32;
altitude1 = 2  //How often we want the game to try switch a height
altitude2 = 4;
altitude3 = 4;
altitudecheck = 0;
altitude = choose(4);

left_loop = global.right_currenty - startingy;
left_loop = left_loop / 32;

for(i=0; i<left_loop; i++)
{
    altitudecheck++;
    bush++;
    pitfall++;
    grasschance = 65;
    

    var block = instance_create(currentx, currenty, obj_block);
    block.image_index = 6;
    
    /*
    for(j=0; j<1; j++)
    {
        instance_create(currentx, currenty+(32*j), obj_block);
    }
    */
    
    //Height changer.
    if(i < blocksize - 4)
    {
        if(altitudecheck >= altitude)
        {
            altitude = choose(altitude1, altitude2, altitude3);
            temp = random_range(0,100)
            
            //Use our % change to make
            if(altitudechance >= temp)
            {
                temp2 = choose(32,-32);
                currentx += temp2;
            }
            
            //Reset checker
            altitudecheck = 0
        }
    }
    
    global.left_currentx = currentx;
    global.left_currenty = currenty;
    
    //Next row.
    currenty += 32;
}

//Create portals for left corner
instance_create(global.left_currentx - (16*6), global.left_currenty + 16, obj_LeftPortal);
instance_create(global.left_currentx + 16, global.left_currenty + (16*4), obj_DownPortal);







//Down
down_loop = (global.right_currentx - currentx)
down_loop = down_loop / 32



//currenty += 32;
altitude1 = 2;  //How often we want the game to try switch a height
altitude2 = 4;
altitude3 = 2;
altitudecheck = 0;
altitude = choose(4);

for(i=0; i< down_loop * 2; i++)
{
    //altitudecheck++;
    bush++;
    pitfall++;
    grasschance = 65;
    
    

    var block = instance_create(currentx, currenty, obj_block);
    block.image_index = 8;
    
    //Bottom Left Corner
    if(i == 0)
    {
        block.image_index = 4;   
    }

    
    //Height changer.
    if(altitudecheck >= altitude)
    {
        altitude = choose(altitude1, altitude2, altitude3);
        temp = random_range(0,100)
        
        //Use our % change to make
        if(altitudechance >= temp)
        {
            temp2 = choose(32,-32);
            currenty += temp2;
        }
        
        //Reset checker
        altitudecheck = 0
    }
    
    
    //Next column.
    currentx += 32;
    
    /*
    if(currentx >= right_currentx)
    {
        i = 30;
    }
    */
}

global.downsidex = currentx;
global.downsidey = currenty - 32;



/*
//Fill in dirt!
for(i=0; i<50; i++)
{
    //Corners (right)
    var block = instance_create(0 + (i*32),startingy,obj_block);
    block.image_index = 1
    if (block != noone)
    {
        //var dirtblock = instance_create(0 + (i*32),startingy,obj_block);
        //dirtblock.image_index = 1;
    }
    else
    {
       // var dirtblock = instance_create(0 + (i*32),startingy,obj_block);
        //dirtblock.image_index = 1;
    }
}