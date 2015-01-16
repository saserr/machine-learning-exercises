package at.tuwien.ml;

import at.tuwien.ml.model.Analysis;
import weka.classifiers.Evaluation;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.*;
import java.util.concurrent.Future;

import static weka.core.Utils.arrayToString;
import static weka.core.Utils.doubleToString;

public final class Main {

    public static void main(final String... args) {
        try {
            if (args.length < 1) {
                System.err.println("At least one arguments is required! Arguments: <data> [<analysis>]"); //NON-NLS
            } else {
                final ConverterUtils.DataSource source = new ConverterUtils.DataSource(args[0]);
                final Instances data = source.getDataSet();
                // setting class attribute if the data format does not provide this information
                // For example, the XRFF format saves the class attribute information as well
                if (data.classIndex() == -1) {
                    System.out.println("Class attribute is missing in data! Using the last attribute"); //NON-NLS
                    data.setClassIndex(data.numAttributes() - 1);
                }

                final Analysis analysis;
                try (final Reader reader = ((args.length < 2) || (args[1] == null) || !new File(args[1]).exists()) ?
                        new InputStreamReader(Main.class.getResourceAsStream("/default.json")) :
                        new FileReader(args[1])) {
                    analysis = Json.deserialize(reader, Analysis.class);
                }

                Pair<String, Result> best = null;
                final Map<Integer, Integer> votes = new HashMap<>(data.numAttributes());
                for (int i = 0; i < data.numAttributes(); i++) {
                    votes.put(i, 0);
                }

                final Pair<String, Future<Result>>[] results = analysis.run(data);
                for (final Pair<String, Future<Result>> pair : results) {
                    final String name = pair.first;
                    System.out.println(name + ':'); //NON-NLS
                    final Result result = pair.second.get();

                    final int[] attributes = result.getAttributes();
                    for (final int attribute : attributes) {
                        votes.put(attribute, votes.get(attribute) + 1);
                    }

                    final Evaluation evaluation = result.getEvaluation();
                    final double fMeasure = evaluation.weightedFMeasure();
                    if ((best == null) || (best.second.getEvaluation().weightedFMeasure() < fMeasure)) {
                        best = new Pair<>(name, result);
                    }

                    print(result);
                }

                if (best != null) {
                    System.out.println("Best result (" + best.first + "):"); //NON-NLS
                    print(best.second);
                }

                final int majority = Math.round((analysis.getSelections().length / 2.0F) + 0.5F);
                final Set<Integer> majorityAttributes = new HashSet<>();
                for (final Map.Entry<Integer, Integer> vote : votes.entrySet()) {
                    if (vote.getValue() >= majority) {
                        majorityAttributes.add(vote.getKey());
                    }
                }

                final Result majorityResult = new Result(analysis.getClassification(), data, majorityAttributes.toArray(new Integer[majorityAttributes.size()]));
                System.out.println("Mayority result:"); //NON-NLS
                print(majorityResult);
            }
        } catch (final Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void print(final Result result) {
        final int[] attributes = result.getAttributes();
        System.out.println("Attributes: " + arrayToString(attributes) + " (" + attributes.length + " attributes)"); //NON-NLS

        final Evaluation evaluation = result.getEvaluation();
        System.out.println("Weighted F measure: " + doubleToString(evaluation.weightedFMeasure(), 8, 3)); //NON-NLS
        System.out.println("Mean Absolute Error: " + doubleToString(evaluation.meanAbsoluteError(), 8, 3)); //NON-NLS
        System.out.println("Root Mean Squared Error: " + doubleToString(evaluation.rootMeanSquaredError(), 8, 3)); //NON-NLS
        System.out.println();
    }

    private Main() {
        super();
    }
}
