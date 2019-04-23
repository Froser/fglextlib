#version 430 core

const int GM_MOTION_MODE_FREE = 0;
const int GM_MOTION_MODE_RELATIVE = 1;

struct gravity_t
{
	vec3 initialVelocity;
	float _padding_; // initialVelocity's placeholder
	float radialAcceleration;
	float tangentialAcceleration;
};

struct radius_t
{
	float angle;
	float degressPerSecond;
	float radius;
	float deltaRadius;
};

struct particle_t
{
	vec4 color;
	vec4 deltaColor;
	vec3 position;
	vec3 startPosition;
	vec3 changePosition;
	vec3 velocity;
	float _padding_; // velocity's placeholder
	float size;
	float currentSize;
	float deltaSize;
	float rotation;
	float deltaRotation;
	float remainingLife;

	gravity_t gravityModeData;
	radius_t radiusModeData;
};

layout(std430, binding = 0) buffer Particle
{
	particle_t particles[];
};

layout(std140, binding = 1) uniform Constant
{
	vec3 emitterPosition;
	vec3 gravity;
	vec3 rotationAxis;
	float _padding_; // gravity's placeholder
	float dt;
	int motionMode;
};

layout(local_size_x = 1, local_size_y = 1) in;

void main(void)
{
	uint gid = gl_GlobalInvocationID.x;
	/*
	particles[gid].color = vec4(1, 2, 3, 4);
	particles[gid].deltaColor = vec4(5, 6, 7, 8);
	particles[gid].position = vec3(9, 10, 11);
	particles[gid].startPosition = vec3(12, 13, 14);
	particles[gid].changePosition = vec3(15, 16, 17);
	particles[gid].velocity = vec3(18, 19, 20);
	particles[gid].size = 21;
	particles[gid].currentSize = 22;
	particles[gid].deltaSize = 23;
	particles[gid].rotation = 24;
	particles[gid].deltaRotation = 25;
	particles[gid].remainingLife = 26;
	*/
	particles[gid].remainingLife -= dt;
	if (particles[gid].remainingLife > 0)
	{
		vec3 offset = vec3(0);
		vec3 radial = vec3(0);
		vec3 tangential = vec3(0);
		if (abs(particles[gid].changePosition.x) > .01f &&
			abs(particles[gid].changePosition.y) > .01f &&
			abs(particles[gid].changePosition.z) > .01f)
		{
			radial = normalize(particles[gid].gravityModeData.initialVelocity);
		}
		tangential = radial;
		radial *= particles[gid].gravityModeData.initialVelocity;

		tangential.xyz = vec3(-tangential.y, tangential.x, tangential.z);
		tangential *= particles[gid].gravityModeData.tangentialAcceleration;

		offset = (radial + tangential + gravity) * dt;

		particles[gid].gravityModeData.initialVelocity += offset;
		particles[gid].changePosition += particles[gid].gravityModeData.initialVelocity * dt;
		particles[gid].color += particles[gid].deltaColor * dt;
		particles[gid].size = max(0, particles[gid].size + particles[gid].deltaSize * dt);
		particles[gid].rotation += particles[gid].deltaRotation * dt;

		if (motionMode == GM_MOTION_MODE_RELATIVE)
			particles[gid].position = particles[gid].changePosition + emitterPosition - particles[gid].startPosition;
		else
			particles[gid].position = particles[gid].changePosition;
	}
}