package at.tuwien.ml;

import at.tuwien.ml.model.Selection;
import weka.attributeSelection.AttributeSelection;
import weka.core.Instances;
import weka.core.Utils;
import weka.core.converters.ConverterUtils;

import java.io.FileReader;
import java.io.Reader;

public final class Main {

    public static void main(final String... args) {
        try {
            if (args.length < 2) {
                System.err.println("Two arguments are required! Arguments: <data> <selections>"); //NON-NLS
            } else {
                final ConverterUtils.DataSource source = new ConverterUtils.DataSource(args[0]);
                final Instances data = source.getDataSet();
                // setting class attribute if the data format does not provide this information
                // For example, the XRFF format saves the class attribute information as well
                if (data.classIndex() == -1) {
                    System.out.println("Class attribute is missing! Using last attribute"); //NON-NLS
                    data.setClassIndex(data.numAttributes() - 1);
                }

                final Selection[] selections;
                try (Reader reader = new FileReader(args[1])) {
                    selections = Json.deserialize(reader, Selection[].class);
                }

                if (selections.length == 1) {
                    System.out.println("Running 1 selection"); //NON-NLS
                } else {
                    System.out.println("Running " + selections.length + " selections"); //NON-NLS
                }

                for (final Selection selection : selections) {
                    System.out.print(selection.getName() + ": ");
                    final AttributeSelection attributeSelection = selection.create();
                    attributeSelection.SelectAttributes(data);
                    final int[] indices = attributeSelection.selectedAttributes();
                    System.out.print(Utils.arrayToString(indices));
                    System.out.println(" (" + indices.length + " attributes)"); //NON-NLS
                }
            }
        } catch (final Exception ex) {
            ex.printStackTrace();
        }
    }

    private Main() {
        super();
    }
}
