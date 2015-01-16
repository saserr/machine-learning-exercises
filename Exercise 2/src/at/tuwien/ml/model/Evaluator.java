package at.tuwien.ml.model;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import weka.attributeSelection.*;

import java.lang.reflect.Type;

import static weka.core.Utils.splitOptions;

public class Evaluator {

    private final String klass;
    private final String options;

    public Evaluator(final String klass, final String options) {
        super();

        this.klass = klass;
        this.options = options;
    }

    public final String getKlass() {
        return this.klass;
    }

    public final String getOptions() {
        return this.options;
    }

    public final ASEvaluation create() throws Exception {
        return ASEvaluation.forName(this.klass, splitOptions(this.options));
    }

    public static class Json implements JsonDeserializer<Evaluator> {

        private static final String CLASS = "class"; //NON-NLS
        private static final String OPTIONS = "options"; //NON-NLS

        @Override
        public final Evaluator deserialize(final JsonElement element,
                                           final Type type,
                                           final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Evaluator(
                    object.getAsJsonPrimitive(CLASS).getAsString(),
                    object.getAsJsonPrimitive(OPTIONS).getAsString()
            );
        }
    }
}
