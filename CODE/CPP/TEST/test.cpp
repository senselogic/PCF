// -- IMPORTS

#include "base.hpp"
#include "cell.hpp"
#include "cloud.hpp"
#include "compression.hpp"
using namespace pcf;

// -- VARIABLES

LINK_<CLOUD>
    Cloud;

// -- FUNCTIONS

void PrintCell(
    CELL & cell
    )
{
    uint64_t
        buffer_index,
        point_index;

    printf(
        "Cell : %s %s %s (%s)\n",
        GetText( cell.PositionVector.X ).c_str(),
        GetText( cell.PositionVector.Y ).c_str(),
        GetText( cell.PositionVector.Z ).c_str(),
        GetText( cell.PointCount ).c_str()
        );

    cell.SetComponentIndex( 0 );

    for ( point_index = 0;
          point_index < cell.PointCount;
          ++point_index )
    {
        printf(
            "    [%s]",
            GetText( point_index ).c_str()
            );

        for ( buffer_index = 0;
              buffer_index < cell.BufferVector.size();
              ++buffer_index )
        {
            printf(
                " %s",
                GetText( cell.GetComponentValue( Cloud->ComponentVector, buffer_index ) ).c_str()
                );
        }

        printf( "\n" );
    }
}

// ~~

int main(
    int argument_count,
    char ** argument_array
    )
{
    try
    {
        CELL::PostWriteFunction = &PrintCell;
        CELL::PostReadFunction = &PrintCell;

        Cloud = new CLOUD();

        puts( "Reading test.ptx" );
        Cloud->ReadPtxFile( "IN/test.ptx", COMPRESSION::None );

        puts( "Writing test_1.pts" );
        Cloud->WritePtsFile( "OUT/test_1.pts" );

        puts( "Writing test_1.ptx" );
        Cloud->WritePtxFile( "OUT/test_1.ptx" );

        puts( "Writing test_1.pcf" );
        Cloud->WritePcfFile( "OUT/test_1.pcf" );

        Cloud = new CLOUD();

        puts( "Reading test_1.pcf" );
        Cloud->ReadPcfFile( "OUT/test_1.pcf" );

        puts( "Writing test_2.pts" );
        Cloud->WritePtsFile( "OUT/test_2.pts" );

        puts( "Writing test_2.ptx" );
        Cloud->WritePtxFile( "OUT/test_2.ptx" );

        puts( "Writing test_2.pcf" );
        Cloud->WritePcfFile( "OUT/test_2.pcf" );

        Cloud = new CLOUD();

        puts( "Reading test.ptx" );
        Cloud->ReadPtxFile( "IN/test.ptx", COMPRESSION::Discretization, 8, 0.1 );

        puts( "Writing test_3.pts" );
        Cloud->WritePtsFile( "OUT/test_3.pts" );

        puts( "Writing test_3.ptx" );
        Cloud->WritePtxFile( "OUT/test_3.ptx" );

        puts( "Writing test_3.pcf" );
        Cloud->WritePcfFile( "OUT/test_3.pcf" );

        Cloud = new CLOUD();

        puts( "Reading test_3.pcf" );
        Cloud->ReadPcfFile( "OUT/test_3.pcf" );

        puts( "Writing test_4.pts" );
        Cloud->WritePtsFile( "OUT/test_4.pts" );

        puts( "Writing test_4.ptx" );
        Cloud->WritePtxFile( "OUT/test_4.ptx" );

        puts( "Writing test_4.pcf" );
        Cloud->WritePcfFile( "OUT/test_4.pcf" );

        Cloud = new CLOUD();

        puts( "Reading OUT/test_1.pts" );
        Cloud->ReadPtsFile( "OUT/test_1.pts", COMPRESSION::Discretization, 8, 0.1 );

        puts( "Writing test_5.pts" );
        Cloud->WritePtsFile( "OUT/test_5.pts" );

        puts( "Writing test_5.ptx" );
        Cloud->WritePtxFile( "OUT/test_5.ptx" );

        puts( "Writing test_5.pcf" );
        Cloud->WritePcfFile( "OUT/test_3.pcf" );
    }
    catch ( const exception & exception_ )
    {
        cerr << exception_.what() << "\n";
    }

    return 0;
}
