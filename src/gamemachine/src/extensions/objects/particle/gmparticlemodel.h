﻿#ifndef __GMPARTICLE_MODEL__
#define __GMPARTICLE_MODEL__
#include <gmcommon.h>
#include "gmparticle.h"

BEGIN_NS

GM_PRIVATE_OBJECT(GMParticleModel)
{
	GMOwnedPtr<GMGameObject> particleObject;
	GMModel* particleModel = nullptr;
	GMParticleSystem* system = nullptr;
	bool GPUValid = true;
};

//! 表示一个2D粒子，是一个四边形
class GMParticleModel : public GMObject, public IParticleModel
{
	GM_DECLARE_PRIVATE(GMParticleModel)

public:
	GMParticleModel(GMParticleSystem* system);

public:
	virtual void render(const IRenderContext* context) override;

protected:
	GMGameObject* createGameObject(
		const IRenderContext* context
	);

	void update6Vertices(
		GMVertex* vertex,
		const GMVec3& centerPt,
		const GMVec2& halfExtents,
		const GMVec4& color,
		const GMQuat& quat,
		const GMVec3& lookAt,
		GMfloat z = 0
	);

protected:
	virtual void updateData(const IRenderContext* context, void* dataPtr);
	virtual void CPUUpdate(const IRenderContext* context, void* dataPtr) = 0;
	virtual void GPUUpdate(IComputeShaderProgram*, const IRenderContext* context, void* dataPtr);
	virtual GMString getCode() = 0;

protected:
	GMComputeBufferHandle prepareBuffers(IComputeShaderProgram*, const IRenderContext* context, void* dataPtr);
};

class GMParticleModel_2D : public GMParticleModel
{
public:
	using GMParticleModel::GMParticleModel;

protected:
	virtual void CPUUpdate(const IRenderContext* context, void* dataPtr) override;
	virtual GMString getCode() override;
};

class GMParticleModel_3D : public GMParticleModel_2D
{
public:
	using GMParticleModel_2D::GMParticleModel_2D;

protected:
	virtual void CPUUpdate(const IRenderContext* context, void* dataPtr) override;
	virtual GMString getCode() override;
};

END_NS
#endif