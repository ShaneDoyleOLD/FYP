//scr_angle_player(direction)
grav_dir = argument0;
initial_angle = image_angle;
playsound = true

if(grav_dir == "up")
{
    image_angle = lerp (initial_angle, 0, 1);
    image_yscale = 1;
}
if(grav_dir == "right")
{
    image_angle = lerp (initial_angle, -90, 1);
    image_yscale = 1;
    
}
if(grav_dir == "left")
{
    image_angle = lerp (initial_angle, 90, 1);
    image_yscale = 1;
}
if(grav_dir == "down")
{
    image_angle = lerp (initial_angle, 180, 1);
    image_yscale = 1;
}


/*
if(playsound == true)
{

    ///Play sound
    playsound = false;
    var gravitysound= audio_play_sound(GravitySound1, 0, false);
    soundpitch = choose (1,2,3,4,5);
    switch (soundpitch)
    {
    case 1: audio_sound_pitch(gravitysound, 1.2); break;
    case 2: audio_sound_pitch(gravitysound, 1.1); break;
    case 3: audio_sound_pitch(gravitysound, 1.0); break;
    case 4: audio_sound_pitch(gravitysound, 0.9); break;
    case 5: audio_sound_pitch(gravitysound, 0.8); break;
}
}