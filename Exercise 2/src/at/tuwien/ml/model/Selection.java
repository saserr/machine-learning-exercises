package at.tuwien.ml.model;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import weka.attributeSelection.AttributeSelection;

import java.lang.reflect.Type;

public class Selection {

    private final String name;
    private final Evaluator evaluator;
    private final Search search;

    public Selection(final String name, final Evaluator evaluator, final Search search) {
        super();

        this.name = name;
        this.evaluator = evaluator;
        this.search = search;
    }

    public final String getName() {
        return this.name;
    }

    public final Evaluator getEvaluator() {
        return this.evaluator;
    }

    public final Search getSearch() {
        return this.search;
    }

    public final AttributeSelection create() throws Exception {
        final AttributeSelection result = new AttributeSelection();
        result.setEvaluator(this.evaluator.create());
        result.setSearch(this.search.create());
        return result;
    }

    public static class Json implements JsonDeserializer<Selection> {

        private static final String NAME = "name"; //NON-NLS
        private static final String EVALUATOR = "evaluator"; //NON-NLS
        private static final String SEARCH = "search"; //NON-NLS

        @Override
        public final Selection deserialize(final JsonElement element,
                                           final Type type,
                                           final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Selection(
                    object.getAsJsonPrimitive(NAME).getAsString(),
                    context.<Evaluator>deserialize(object.getAsJsonObject(EVALUATOR), Evaluator.class),
                    context.<Search>deserialize(object.getAsJsonObject(SEARCH), Search.class)
            );
        }
    }
}
