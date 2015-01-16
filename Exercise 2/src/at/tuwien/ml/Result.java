package at.tuwien.ml;

import at.tuwien.ml.model.Classification;
import weka.classifiers.Evaluation;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;

import java.util.HashSet;
import java.util.Set;

import static java.lang.System.arraycopy;
import static java.util.Arrays.sort;
import static weka.core.Utils.arrayToString;

public class Result {

    private final int[] attributes;
    private final Evaluation evaluation;

    public Result(final Classification classification,
                  final Instances data,
                  final Integer... attributes) throws Exception {
        this(classification, data, unwrap(attributes));
    }

    public Result(final Classification classification,
                  final Instances data,
                  final int... attributes) throws Exception {
        super();

        this.attributes = new int[attributes.length];
        arraycopy(attributes, 0, this.attributes, 0, this.attributes.length);
        sort(this.attributes);

        final Set<Integer> remaining = new HashSet<>(this.attributes.length);
        for (final int attribute : this.attributes) {
            remaining.add(attribute + 1);
        }
        remaining.add(data.classIndex() + 1);

        final Remove remove = new Remove();
        remove.setOptions(new String[]{"-R", arrayToString(remaining.toArray(new Integer[remaining.size()])), "-V"});
        remove.setInputFormat(data);
        final Instances newData = Filter.useFilter(data, remove);
        if (newData.classIndex() == -1) {
            newData.setClassIndex(newData.numAttributes() - 1);
        }

        this.evaluation = classification.run(newData);
    }

    public final int[] getAttributes() {
        final int[] result = new int[this.attributes.length];
        arraycopy(this.attributes, 0, result, 0, result.length);
        return result;
    }

    private static int[] unwrap(final Integer... values) {
        final int[] result = new int[values.length];
        for (int i = 0; i < values.length; i++) {
            result[i] = values[i];
        }
        return result;
    }

    public final Evaluation getEvaluation() {
        return this.evaluation;
    }
}
