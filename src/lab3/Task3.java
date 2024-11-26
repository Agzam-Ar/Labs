package lab3;

import java.io.IOException;
import java.util.Scanner;

public class Task3 {

	public static void main(String[] args) throws IOException {
		Scanner scanner = new Scanner(System.in);
		String line = scanner.nextLine(); // X.x K M
		scanner.close();
		String[] data = line.split(" ");
		String[] sx = data[0].split("\\.");
		int K = Integer.parseInt(data[1]);
		int M = Integer.parseInt(data[2]);
		
		// k -> 10
		int x1l = 0;
		int mul = 1;
		for (int i = sx[0].length()-1; i >= 0; i--) {
			x1l += (sx[0].charAt(i) - '0')*mul;
			mul *= K;
		}

		int x1r = 0;
		if(sx.length > 1) {
			mul = 1;
			for (int i = sx[1].length()-1; i >= 0; i--) {
				x1r += (sx[1].charAt(i) - '0')*mul;
				mul *= K;
			}
		}
		
		// 10 -> M
		String result = "";
		while (true) {
			result = x1l%M + result;
			x1l /= M;
			if(x1l == 0) break;
		}
		if(sx.length > 1) {
			result += '.';
			for (int i = 0; i < sx[1].length(); i++) {
				x1r *= M;
				int num = x1r/mul;
				x1r -= num*mul;
				result += num;
			}
		}
		System.out.println(result);
	}
	
	
}
