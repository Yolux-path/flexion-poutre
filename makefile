FC = gfortran
FFLAGS = -Wall -Werror
TARGET = main
SRCS = constantes.f90 methode.f90 main.f90
OBJS = $(SRCS:.f90=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET) *.mod
