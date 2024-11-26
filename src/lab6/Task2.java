package lab6;

import java.util.Scanner;
import java.util.Locale;

public class Task2 {

	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in).useLocale(Locale.US);
		int n = scanner.nextInt();
		double[] values = new double[n];

		for (int i = 0; i < n; i++) {
			values[i] = scanner.nextDouble();
		}

		// bubble sort
		for(int i = 0; i < n; i++) {
			for(int j = i+1; j < n; j++) {
				if(values[j] < values[i]) {
					double tmp = values[i];
					values[i] = values[j];
					values[j] = tmp;
				}	
			}
		}

		calc(values, values.length, "");
	}

	private static void calc(double[] values, int size, String suffix) {
		if (values.length == 1) {
			System.out.print(suffix + " ");
			return;
		}
		
		int splitIndex = 1;
		double splitCost = size;

		for (int s = 1; s < size; s++) {
			double l = 0;
			for (int i = 0; i < s; i++) l += values[i];
			double r = 0;
			for (int i = s; i < size; i++) r += values[i];
			if(Math.abs(l-r) < splitCost) {
				splitCost = Math.abs(l-r);
				splitIndex = s;
			}
		}
		
		double[] a = new double[splitIndex];
		double[] b = new double[size - splitIndex];
		for(int i = 0; i < splitIndex; i++) a[i] = values[i];
		for(int i = 0; i < size - splitIndex; i++) b[i] = values[i+splitIndex];

		calc(b, size-splitIndex, suffix + "0");
		calc(a, splitIndex, suffix + "1");
	}

}