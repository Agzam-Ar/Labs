

typedef struct LinkedList {

	struct LinkedListNode* current;

} LinkedList;

typedef struct LinkedListNode {

	char* value;
	struct LinkedListNode* next;
	struct LinkedListNode* prev;

} LinkedListNode;

LinkedList* create();

//LinkedListNode* createList();
void append(LinkedList* list, char* arg);
void prepend(LinkedList* list, char* arg);
void lremove(LinkedList* list, char* arg);
void next(LinkedList* list, char* arg);
void previous(LinkedList* list, char* arg);


void printList(LinkedList* list);
