#!/usr/bin/env bash

cd ~/workdir

gatk SelectVariants \
--variant results/variants/trio.vcf \
--select-type-to-include INDEL \
--output results/variants/trio.INDEL.vcf
