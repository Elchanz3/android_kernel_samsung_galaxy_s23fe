/*
 *  Copyright (C) 2020, Samsung Electronics Co. Ltd. All Rights Reserved.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 */

#include "../../accelerometer.h"
#include "../../../sensormanager/shub_sensor_manager.h"
#include "../../../sensormanager/shub_sensor_type.h"
#include "../../../sensormanager/shub_sensor.h"
#include "../../../utility/shub_utility.h"

#include <linux/device.h>
#include <linux/of_gpio.h>

#define LIS2DLC12_NAME		"LIS2DLC12"
static void parse_dt_accelerometer_lis2dlc12(struct device *dev)
{
	struct accelerometer_data *data = get_sensor(SENSOR_TYPE_ACCELEROMETER)->data;
	struct device_node *np = dev->of_node;

	if (of_property_read_u32(np, "acc-lis2dlc12-position", &data->position))
		data->position = 0;
	shub_infof("position[%d]", data->position);
}

struct sensor_chipset_init_funcs accel_lis2dlc12_ops = {
	.parse_dt = parse_dt_accelerometer_lis2dlc12,
};

struct sensor_chipset_init_funcs *get_accelerometer_lis2dlc12_function_pointer(char *name)
{
	if (strcmp(name, LIS2DLC12_NAME) != 0)
		return NULL;

	return &accel_lis2dlc12_ops;
}
