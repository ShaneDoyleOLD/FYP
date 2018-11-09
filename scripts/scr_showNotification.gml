var text = argument[0];

with (obj_message)
{
    instance_destroy();
}

var notification = instance_create(0, 0, obj_message);
notification.message = text;