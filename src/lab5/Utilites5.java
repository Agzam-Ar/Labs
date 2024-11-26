package lab5;

import java.util.Scanner;

public class Utilites5 {

	static void calc(int a, int b, boolean invert) {
		Scanner scanner = new Scanner(System.in);
		String[] line = scanner.nextLine().split(" ");
		scanner.close();
		int resultLength = Integer.parseInt(line[1]);
		int mantissaLength = Integer.parseInt(line[2]);
		int exponentLength = resultLength - mantissaLength - 1;
		int[] result = new int[resultLength];
		String[] sx = line[0].split("\\.");
		if(line[0].charAt(0) == '-') result[0] = 1;
		else result[0] = 0;
		int x1l = 0;
		int mul = 1;
		for (int i = sx[0].length()-1; i >= result[0]; i--) {
			x1l += (sx[0].charAt(i) - '0')*mul;
			mul *= 10;
		}
		int x1r = 0;
		if(sx.length > 1) {
			mul = 1;
			for (int i = sx[1].length()-1; i >= 0; i--) {
				x1r += (sx[1].charAt(i) - '0')*mul;
				mul *= 10;
			}
		}
		int shift = (int) ((Math.ceil(Math.log(x1l+1) / Math.log(2)))-a);
		if(shift > ((1L << (exponentLength-1))-1)) {
			System.out.println(result[0] + "111110000000000");
		} else {
			for (int i = 0; i <= shift; i++) 
				if(((1 << i) & x1l) == 0) result[exponentLength + shift - i] = 0;
				else result[exponentLength + shift - i] = 1;
			if(x1l == 0) shift = 0;
			for (int i = 0; exponentLength + i + 1 + shift < resultLength; i++) {
				x1r *= 2;
				int num = x1r/mul;
				x1r -= num*mul;
				if(x1l == 0) shift--;
				if(num == 1) x1l = 1;
				if(x1l == 0) continue;
				result[exponentLength + i + 1 + shift] = num;
			}
			shift += (1L << (exponentLength-1))-b;
			if(shift < 0) {
				System.out.println(result[0] + "000000000000000");
			} else {
				for (int i = 0; i < exponentLength; i++)
					if(((1 << i) & shift) == 0) result[exponentLength-i] = 0;
					else result[exponentLength-i] = 1;
				
				if(invert) {
					System.out.print(result[0]);
					System.out.print("|");
					for (int i = 0; i < mantissaLength; i++) System.out.print(result[i+exponentLength+1]);
					System.out.print("|");
					for (int i = 0; i < exponentLength; i++) System.out.print(result[exponentLength-i]);
				} else {
					for (int i = 0; i < resultLength; i++) System.out.print(result[i]);
				}
			}
		}
	}
	
}
