#ifndef MINIPSEUDTREE
# define MINIPSEUDTREE
    
enum NodeType {
	NTEMPTY      = 330,
	NTINSTLIST   = 331,
	NTEXPR       = 332,
	NTAFF        = 333,
	NTSHOW       = 334,
    NTNUM        = 335,
    NTVAR        = 336,
    NTPLUS       = 337,
	NTMIN        = 338,
	NTMULT       = 339,
	NTDIV        = 340,
	NTPOW        = 341,
    NTVAREXPR    = 342,
    NT_EQUALS    = 343,
    NT_NOTEQUALS = 344,
    NT_INF       = 345,
    NT_SUP       = 346,
    NT_INFEQUALS = 347,
    NT_SUPEQUALS = 348,
    NTIF         = 349,
    NTELSE       = 350,
    NTIFELSE     = 351,
    NTFLOOP         = 352,
    NTREPEAT        = 353,
    NTREPEATSTATIC  = 354,
    NTFOR           = 355
};
   
typedef struct Node {
	enum NodeType type;
	union { 
		double val;
		char* var;
		struct Node** children;
	} ;
} Node;

Node* createNode(int type);

Node* nodeChildren(Node* father, Node *child1, Node *child2);

const char* node2String(Node *node);

void printGraph(Node *root);

#endif
