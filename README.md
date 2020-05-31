# fairseq_summarization_sample

## 1. Sample Execution

1. Put the source and target file of summarization in the specified directory(ex. orig/ja/).   
Each file must contain original texts and summarized texts respectively.  
Put one text on one line in each file. The original text of the source file and  
the summary text of the target file should appear on the same line number in each file.
1. Put train.source and train.target into orig/<lang>(ex. orig/ja/) directory.
1. Run 1_prepare.sh, 2_preprocess.sh and 3_train.sh sequentially. 
1. Run 4_evaluate.sh to test summarization models.

## 2. Notes
If your GPU has less than 8GB of memory, you should use lstm or transformer as the value for the --arch option when training.
