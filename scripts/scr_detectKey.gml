if (!global.typing)
{
    //Movement
    rightKey = keyboard_check(vk_right);
    leftKey = keyboard_check(vk_left);
    jumpKey = keyboard_check(vk_up);
    sprintKey = keyboard_check(vk_shift);
    duckKey = keyboard_check(ord("+"));
    
    //Attack
    attackKey = keyboard_check_pressed(vk_space);
}