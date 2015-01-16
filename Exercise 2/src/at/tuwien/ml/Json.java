package at.tuwien.ml;

import at.tuwien.ml.model.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.Reader;

public final class Json {

    private static final Gson GSON = new GsonBuilder()
            .registerTypeAdapter(Analysis.class, new Analysis.Json())
            .registerTypeAdapter(Classification.class, new Classification.Json())
            .registerTypeAdapter(Selection.class, new Selection.Json())
            .registerTypeAdapter(Evaluator.class, new Evaluator.Json())
            .registerTypeAdapter(Search.class, new Search.Json())
            .create();

    public static <T> T deserialize(final Reader reader, final Class<T> klass) {
        return GSON.fromJson(reader, klass);
    }

    private Json() {
        super();
    }
}
