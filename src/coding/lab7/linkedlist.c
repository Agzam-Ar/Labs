#include "linkedlist.h"
#include <stdlib.h>
#include <stdio.h>

static LinkedListNode* createNode() {
	return malloc(sizeof(LinkedListNode));
}

LinkedList* create() {
	/*LinkedListNode* node = createNode();
	node->next = node;
	node->prev = node;*/

	LinkedList* list = (LinkedList*) malloc(sizeof(LinkedList));
	list->current = NULL;
	return list;
}


void printList(LinkedList* list) {
	printf("Current state:\n");
	LinkedListNode* first = list->current;
	if (first == NULL) {
		printf("<empty>\n");
		return;
	}

	printf("-[%s]\n", first->value);
	LinkedListNode* current = first->next;
	while (first != current) {
		printf("- %s\n", current->value);
		current = current->next;
	}
}

void append(LinkedList* list, char* arg) {
	LinkedListNode* node = createNode();
	node->value = arg;
	if (list->current == NULL) {
		node->next = node;
		node->prev = node;
		list->current = node;
		return;
	}
	node->next = list->current->next;
	node->prev = list->current;
	list->current->next->prev = node;
	list->current->next = node;
}

void prepend(LinkedList* list, char* arg) {
	LinkedListNode* node = createNode();
	node->value = arg;
	if (list->current == NULL) {
		node->next = node;
		node->prev = node;
		list->current = node;
		return;
	}
	node->next = list->current;
	node->prev = list->current->prev;
	list->current->prev->next = node;
	list->current->prev = node;
}

void lremove(LinkedList* list, char* arg) {
	if (list->current == NULL) return;
	LinkedListNode* target = list->current;
	if (target->next == target) {
		list->current = NULL;
		return;
	}
	list->current = target->next;
	target->prev->next = target->next;
	target->next->prev = target->prev;
	free(target);
}

void next(LinkedList* list, char* arg) {
	if (list->current == NULL) return;
	list->current = list->current->next;
}

void previous(LinkedList* list, char* arg) {
	if (list->current == NULL) return;
	list->current = list->current->prev;
}

