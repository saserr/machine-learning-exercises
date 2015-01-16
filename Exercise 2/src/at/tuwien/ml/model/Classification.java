package at.tuwien.ml.model;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.core.Instances;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.Random;

import static weka.core.Utils.splitOptions;

public class Classification implements Serializable {

    private static final long serialVersionUID = 3057139069107023445L;

    private final String klass;
    private final String options;
    private final int folds;
    private final int seed;

    public Classification(final String klass, final String options, final int folds, final int seed) {
        super();

        this.klass = klass;
        this.options = options;
        this.folds = folds;
        this.seed = seed;
    }

    public final String getKlass() {
        return this.klass;
    }

    public final String getOptions() {
        return this.options;
    }

    public final int getFolds() {
        return this.folds;
    }

    public final int getSeed() {
        return this.seed;
    }

    public final Classifier create() throws Exception {
        return Classifier.forName(this.klass, splitOptions(this.options));
    }

    public final Evaluation run(final Instances data) throws Exception {
        final Classifier classifier = create();
        final Evaluation result = new Evaluation(data);
        result.crossValidateModel(classifier, data, this.folds, new Random(this.seed));
        return result;
    }

    public static class Json implements JsonDeserializer<Classification> {

        private static final String CLASS = "class"; //NON-NLS
        private static final String OPTIONS = "options"; //NON-NLS
        private static final String FOLDS = "folds"; //NON-NLS
        private static final String SEED = "seed"; //NON-NLS

        @Override
        public final Classification deserialize(final JsonElement element,
                                                final Type type,
                                                final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Classification(
                    object.getAsJsonPrimitive(CLASS).getAsString(),
                    object.getAsJsonPrimitive(OPTIONS).getAsString(),
                    object.getAsJsonPrimitive(FOLDS).getAsInt(),
                    object.getAsJsonPrimitive(SEED).getAsInt()
            );
        }
    }
}
