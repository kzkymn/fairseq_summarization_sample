# adapted from https://datanerd.hateblo.jp/entry/2019/09/11/122322

from sklearn.utils import shuffle


def split(srcfile="tmp/train.tokenized.source",
          tgtfile="tmp/train.tokenized.target",
          valid_size=0.05,
          test_size=0.15):

    with open(srcfile, errors='ignore') as fsrc, open(tgtfile, errors='ignore') as ftgt:
        data = shuffle(list(zip(fsrc, ftgt)))
    tmp_size_abs = int(len(data) * (valid_size + test_size))
    tmp = data[:tmp_size_abs]
    train = data[tmp_size_abs:]
    valid_size_abs = int(len(tmp) * (valid_size / (test_size + valid_size)))
    valid = tmp[:valid_size_abs]
    test = tmp[valid_size_abs:]
    tmpdir = "tmp/splitted/"

    for x in [("train.source", "train.target", train), ("valid.source", "valid.target", valid),
              ("test.source", "test.target", test)]:

        with open(tmpdir + x[0], "w") as fsrc, open(tmpdir + x[1],
                                                    "w") as ftgt:
            for row in x[2]:
                fsrc.write(row[0].strip() + "\n")
                ftgt.write(row[1].strip() + "\n")


if __name__ == "__main__":
    split()
