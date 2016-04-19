# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fdaudre- <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2014/07/15 15:13:38 by fdaudre-          #+#    #+#              #
#    Updated: 2016/01/07 15:33:44 by fdaudre-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#################
##  VARIABLES  ##
#################

#	Sources
SRCDIR		=	src
SRC			=	foo.c				\
				sub/bar.c

#	Objects
OBJDIR		=	obj

#	Includes
CPPFLAGS	=	-Iinc -Ilibft

#	Libraries
LDFLAGS		=	-Llibft
LDLIBS		=	-lft

#	Output
NAME		=	binary

#	Compiler
CFLAGS		=	-Werror -Weverything


#################
##  AUTO       ##
#################

OBJ			=	$(addprefix $(OBJDIR)/,$(notdir $(SRC:.c=.o)))
NORME		=	**/*.[ch]
VPATH		+=	$(dir $(addprefix $(SRCDIR)/,$(SRC)))

disp_indent	=	for I in `seq 1 $(MAKELEVEL)`; do \
					test "$(MAKELEVEL)" '!=' '0' && printf "\t"; \
				done
color_exec	=	$(call disp_indent); \
				echo "\033["$(1)"m➤"$(3)"\033["$(2)"m";$(3) && printf "\033[0m"


#################
##  TARGETS    ##
#################

#	First target
all: $(NAME)

#	Linking
$(NAME): $(OBJ)
	@$(call color_exec,0,0,\
		$(MAKE) -C libft)
	@$(call color_exec,32,31,\
		$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $^)

#	Objects compilation
$(OBJDIR)/%.o: %.c
	@mkdir $(OBJDIR) 2> /dev/null || true
	@$(call color_exec,36,31,\
		$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<)

#	Removing objects
clean:
	@$(call color_exec,33,31,\
		$(RM) $(OBJ))
	@rmdir $(OBJDIR) 2> /dev/null || true

#	Removing objects and exe
fclean: clean
	@$(call color_exec,33,31,\
		$(RM) $(NAME))

#	All removing then compiling
re: fclean all

#	Checking norme
norme:
	@norminette $(NORME) | sed "s/Norme/[0;1;37m➤ [0;38;5;254mNorme/g;s/Warning/[0;31mWarning/g;s/Error/[0;31mError/g"

run: $(NAME)
	@echo "\033[0;1;35m➤ \033[0;38;5;147m./$(NAME) ${ARGS}\033[0m"
	@./$(NAME) ${ARGS}

codesize:
	@cat $(NORME) |grep -v '/\*' |wc -l

.PHONY: all clean fclean re norme codesize
