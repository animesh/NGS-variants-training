
## Learning outcomes

**After having completed this chapter you will be able to:**

- Describe the aims of variant annotation
- Explain how variants are ranked in order of importance
- Explain how splice variation affects variant annotation
- Perform a variant annotation with `snpEff`
- Interpret the report generated by `snpEff`
- Explain how variant annotation can be added to a `vcf` file

## Material

<iframe width="560" height="315" src="https://www.youtube.com/embed/DxuQ63jFMtM?si=SvQ5mVKjlIIS6A6h" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

[:fontawesome-solid-file-pdf: Download the presentation](../assets/pdf/07_variant_annotation.pdf){: .md-button }

## Exercises

To use the human genome as a reference, we have downloaded the database with:

!!! warning "No need to download, it's already downloaded for you"

```sh
# don't run this. It's already downloaded for you
snpEff download -v GRCh38.99
```

You can run snpEff like so:

```sh
mkdir annotation

snpEff -Xmx4g \
-v \
GRCh38.99 \
<filtered_variants.vcf> \
> <annotated_variants.vcf>
```

**Exercise:** Run the command on the filtered vcf (`trio.filtered.vcf`) using a script called `C18_annotate_snpEff.sh`. Check out the html file (`snpEff_summary.html`). Try to answer these questions:

**A.** How many effects were calculated?

**B.** How many variants are in the vcf?

**C.** Why is this different?

**D.** How many effects result in a missense mutation?

??? done "Answer"

    Your script:

    ```sh title="C18_annotate_snpEff.sh"
    #!/usr/bin/env bash

    cd ~/workdir/results/variants

    snpEff -Xmx4g \
    -v \
    GRCh38.99 \
    trio.filtered.vcf \
    > trio.filtered.snpeff.vcf
    ```

    A. There were 10,357 effects calculated.

    B. There are only 556 variants in the vcf.

    C. This means that there are multiple effects per variant. snpEff calculates effects for each splice variant, and therefore the number of effects are a multitude of the number of variants.

    D. Two effects result in a missense mutation.

You can (quick and dirty) query the annotated vcf for the missense mutation with `grep`.

**Exercise:** Find the variant causing the missense mutation (the line contains the string `missense`). And answer the following questions:

??? hint "Hint"
    ```sh
    grep missense trio.filtered.snpeff.vcf 
    ```

Run the command and have a look at the SnpEff [ANN field documentation](http://pcingola.github.io/SnpEff/se_inputoutput/#ann-field-vcf-output-files). Answer the following questions:

**A.** How are the SNP annotations stored in the vcf?

**B.** What are the genotypes of the individuals?

**C.** Which amino acid change does it cause?

??? done "Answer"

    Find the line with the missense mutation like this:

    ```sh
    grep missense annotation/trio.filtered.snpeff.vcf
    ```

    This results in (truncated long line, scroll to the right to see more):

    ```
    chr20   10049540        .       T       A       220.29  PASS    AC=1;AF=0.167;AN=6;BaseQRankSum=-6.040e-01;DP=85;ExcessHet=3.0103;FS=0.000;MLEAC=1;MLEAF=0.167;MQ=60.00;MQRankSum=0.00;QD=8.16;ReadPosRankSum=0.226;SOR=0.951;ANN=A|missense_variant|MODERATE|ANKEF1|ENSG00000132623|transcript|ENST00000378392.6|protein_coding|7/11|c.971T>A|p.Leu324Gln|1426/5429|971/2331|324/776||,A|missense_variant|MODERATE|ANKEF1|ENSG00000132623|transcript|ENST00000378380.4|protein_coding|6/10|c.971T>A|p.Leu324Gln|1300/5303|971/2331|324/776||       GT:AD:DP:GQ:PL  0/0:34,0:34:99:0,102,1163       0/1:17,10:27:99:229,0,492       0/0:24,0:24:72:0,72,811
    ```

    A. SNP annotations are stored in the INFO field, starting with `ANN=`

    B. The genotypes are homozygous reference for the father and son, and heterozygous for the mother. (find the order of the samples with `grep ^#CHROM`)

    C. The triplet changes from cTg to cAg, resulting in a change from Leu (Leucine) to Gln (Glutamine).
