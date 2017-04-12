﻿#ifndef __PHYSICSSTRUCTS_H__
#define __PHYSICSSTRUCTS_H__
#include "common.h"
#include <map>
#include "utilities/vmath.h"
BEGIN_NS

class GameObject;

struct ShapeProperties
{
	GMfloat stepHeight;
	vmath::vec3 bounding[2]; //最小边界和最大边界
};

struct MotionProperties
{
	vmath::vec3 translation;
	vmath::vec3 velocity;
};

struct CollisionObject
{
	GameObject* object;
	MotionProperties motions;
	ShapeProperties shapeProps;
};

END_NS
#endif