del /q test.exe
dmd -debug -g -gf -gs -m64 -oftest.exe test.d ../base.d ../buffer.d ../cell.d ../cell_position_vector.d ../cloud.d ../component.d ../compression.d ../image.d ../property.d ../scalar.d ../scan.d ../stream.d ../vector_3.d ../vector_4.d
del /q test.obj
del /q test.ilk
del /q test.pdb
test.exe
