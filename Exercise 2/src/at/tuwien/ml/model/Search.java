package at.tuwien.ml.model;

import com.google.gson.*;
import weka.attributeSelection.ASSearch;
import weka.core.Utils;

import java.lang.reflect.Type;

import static weka.core.Utils.splitOptions;

public class Search {

    private final String klass;
    private final String options;

    public Search(final String klass, final String options) {
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

    public final ASSearch create() throws Exception {
        return (ASSearch) Utils.forName(ASSearch.class, this.klass, splitOptions(this.options));
    }

    public static class Json implements JsonDeserializer<Search> {

        private static final String CLASS = "class"; //NON-NLS
        private static final String OPTIONS = "options"; //NON-NLS

        @Override
        public final Search deserialize(final JsonElement element,
                                        final Type type,
                                        final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Search(
                    object.getAsJsonPrimitive(CLASS).getAsString(),
                    object.getAsJsonPrimitive(OPTIONS).getAsString()
            );
        }
    }
}
