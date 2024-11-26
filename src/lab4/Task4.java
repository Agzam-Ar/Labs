package lab4;

import java.util.Scanner;

public class Task4 {

	// расстояние по Хеммингу двух дополнительных кодов
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		long a = scanner.nextLong();
		long b = scanner.nextLong();
		int size = scanner.nextInt();
		scanner.close();
		long c = (1 << (size-1));
		a = (c ^ a) - c;
		b = (c ^ b) - c;
		int dst = 0;
		for (int i = size-1; i >= 0; i--) {
			long mask = 1L << i;
			if(((a & mask) == 0 ? 0 : 1) != ((b & mask) == 0 ? 0 : 1)) dst++;
		}
		System.out.println(dst);
	}
}
