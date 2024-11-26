package lab3;

import java.io.IOException;
import java.util.Scanner;

public class Task4 {

	public static void main(String[] args) throws IOException {
		
		Scanner scanner = new Scanner(System.in);
		int N = scanner.nextInt();
		long[] basises = new long[N];
		long[] as = new long[N];
		long[] bs = new long[N];
		long p = 1;
		for (int i = 0; i < N; i++) {
			basises[i] = scanner.nextLong();
			p *= basises[i];
		}
		for (int i = 0; i < N; i++) {
			as[i] = scanner.nextLong();
		}
		for (int i = 0; i < N; i++) {
			bs[i] = scanner.nextLong();
		}
		scanner.close();

		long a10 = 0;
		long b10 = 0;
		for (int i = 0; i < basises.length; i++) {
			long w = 0;
			long b = p / basises[i];
			for (w = 0; true; w++) {
				if((w*b)%basises[i] == 1) break;
			}
			a10 += as[i] * p / basises[i] * w;
			b10 += bs[i] * p / basises[i] * w;
		}
		a10 %= p;
		b10 %= p;
		
		if(a10 + b10 >= p) System.out.println(-1);
		else System.out.println(a10 + b10);
	}
	
}
