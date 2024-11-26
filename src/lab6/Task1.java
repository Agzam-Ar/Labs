package lab6;

import java.util.Scanner;

public class Task1 {
	
	
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		long n = scanner.nextLong();
		scanner.close();
		
		long size = (long) Math.ceil(Math.log(n)/Math.log(2));
		
		for(long i = 0; i < n; i++) {
			for(long e = size-1; e >= 0; e--) {
				System.out.print((i & (1 << e)) == 0 ? 0 : 1);
			}
			System.out.print(" ");
		}
		
	}
}