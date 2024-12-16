/*
N -натуральных чисел являются элементами двунаправленного списка L, вычислить: X1*Xn+X2*Xn-1+...+Xn*X1. 
Вывести на экран каждое произведение и итоговую сумму.
*/
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

typedef struct Node Node;

struct Node {
	int value;
	Node* next;
	Node* prev;
};

void printNode(Node* node) {
	printf("%d -> %d -> %d", 
		node->prev == NULL ? -1 : node->prev->value,
		node->value, 
		node->next == NULL ? -1 : node->next->value);
}

int main() {
	int n = 10;
	scanf("%d", &n);

	Node tmp = { 0 };
	tmp.value = 0;
	Node* current = &tmp;
	scanf("%d", &current->value);
	current->next = &tmp;
	current->prev = &tmp;
	for (int i = 1; i < n; i++) {
		Node* insert = malloc(sizeof(Node));
		scanf("%d", &insert->value);
		insert->next = current->next;
		current->next = insert;
		insert->prev = current;
		current = insert;
	}
	tmp.prev = current;

	// logic

	int sum = 0;
	Node* a = &tmp;
	Node* b = (&tmp)->prev;
	while (1) {
		sum += a->value * b->value;
		printf("%d*%d\n", a->value, b->value);
		if (b == &tmp) break;
		a = a->next;
		b = b->prev;
	}
	printf("SUM: %d\n", sum);
}

