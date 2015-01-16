package at.tuwien.ml.model;

import at.tuwien.ml.Pair;
import at.tuwien.ml.Result;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import weka.core.Instances;

import java.lang.reflect.Type;
import java.util.concurrent.Future;

import static java.lang.System.arraycopy;

public class Analysis {

    private final Classification classification;
    private final Selection[] selections;

    public Analysis(final Classification classification, final Selection... selections) {
        super();

        this.classification = classification;
        this.selections = new Selection[selections.length];
        arraycopy(selections, 0, this.selections, 0, this.selections.length);
    }

    public final Classification getClassification() {
        return this.classification;
    }

    public final Selection[] getSelections() {
        final Selection[] result = new Selection[this.selections.length];
        arraycopy(this.selections, 0, result, 0, result.length);
        return result;
    }

    @SuppressWarnings("unchecked")
    public final Pair<String, Future<Result>>[] run(final Instances data) {
        if (this.selections.length == 1) {
            System.out.println("Running 1 selection"); //NON-NLS
        } else {
            System.out.println("Running " + this.selections.length + " selections in parallel"); //NON-NLS
        }

        final Pair<String, Future<Result>>[] result = new Pair[this.selections.length];

        for (int i = 0; i < this.selections.length; i++) {
            final Selection selection = this.selections[i];
            result[i] = new Pair<>(selection.getName(), selection.run(this.classification, data));
        }

        return result;
    }

    public static class Json implements JsonDeserializer<Analysis> {

        private static final String CLASSIFICATION = "classification"; //NON-NLS
        private static final String SELECTIONS = "selections"; //NON-NLS

        @Override
        public final Analysis deserialize(final JsonElement element,
                                          final Type type,
                                          final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Analysis(
                    context.<Classification>deserialize(object.get(CLASSIFICATION), Classification.class),
                    context.<Selection[]>deserialize(object.get(SELECTIONS), Selection[].class)
            );
        }
    }
}
