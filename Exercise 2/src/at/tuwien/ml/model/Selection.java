package at.tuwien.ml.model;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import weka.attributeSelection.AttributeSelection;
import weka.core.Instances;

import java.lang.reflect.Type;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Selection {

    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());

    private final String name;
    private final Evaluator evaluator;
    private final Search search;
    private final int folds;
    private final int seed;

    public Selection(final String name,
                     final Evaluator evaluator,
                     final Search search,
                     final int folds,
                     final int seed) {
        super();

        this.name = name;
        this.evaluator = evaluator;
        this.search = search;
        this.folds = folds;
        this.seed = seed;
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

    public final int getFolds() {
        return this.folds;
    }

    public final int getSeed() {
        return this.seed;
    }

    public final AttributeSelection create() throws Exception {
        final AttributeSelection result = new AttributeSelection();
        result.setEvaluator(this.evaluator.create());
        result.setSearch(this.search.create());
        if (this.folds > 1) {
            result.setXval(true);
            result.setFolds(this.folds);
            result.setSeed(this.seed);
        } else {
            result.setXval(false);
        }
        return result;
    }

    public final Future<AttributeSelection> run(final Instances data) {
        return EXECUTOR.submit(new Callable<AttributeSelection>() {
            @Override
            public AttributeSelection call() throws Exception {
                final AttributeSelection selection = create();
                selection.SelectAttributes(data);
                return selection;
            }
        });
    }

    public static class Json implements JsonDeserializer<Selection> {

        private static final String NAME = "name"; //NON-NLS
        private static final String EVALUATOR = "evaluator"; //NON-NLS
        private static final String SEARCH = "search"; //NON-NLS
        private static final String FOLDS = "folds"; //NON-NLS
        private static final String SEED = "seed"; //NON-NLS

        @Override
        public final Selection deserialize(final JsonElement element,
                                           final Type type,
                                           final JsonDeserializationContext context) {
            final JsonObject object = element.getAsJsonObject();
            return new Selection(
                    object.getAsJsonPrimitive(NAME).getAsString(),
                    context.<Evaluator>deserialize(object.getAsJsonObject(EVALUATOR), Evaluator.class),
                    context.<Search>deserialize(object.getAsJsonObject(SEARCH), Search.class),
                    object.has(FOLDS) ? object.getAsJsonPrimitive(FOLDS).getAsInt() : -1,
                    object.has(SEED) ? object.getAsJsonPrimitive(SEED).getAsInt() : 5
            );
        }
    }
}
