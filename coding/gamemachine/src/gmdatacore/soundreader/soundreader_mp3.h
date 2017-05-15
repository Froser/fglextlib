﻿#ifndef __SOUNDREADER_MP3_H__
#define __SOUNDREADER_MP3_H__
#include "common.h"
#include "soundreader.h"
#include <vector>
BEGIN_NS

struct SoundReader_MP3Private
{
	bool formatCreated;
	bool bufferLoaded;
	WAVEFORMATEX format;
	GamePackageBuffer* bufferIn;
	std::vector<GMbyte> bufferOut;
};

class SoundReader_MP3 : public ISoundReader
{
	DEFINE_PRIVATE(SoundReader_MP3)

public:
	virtual bool load(GamePackageBuffer& buffer, OUT ISoundFile** sf) override;
	virtual bool test(const GamePackageBuffer& buffer) override;

private:
	bool decode();
};

END_NS
#endif