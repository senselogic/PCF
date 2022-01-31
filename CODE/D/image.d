module pcf.image;

// -- IMPORTS

import pcf.file;
import pcf.property;

// -- TYPES

class IMAGE
{
    // -- ATTRIBUTES

    string
        Name,
        Role,
        Format;
    PROPERTY[]
        PropertyArray;
    ubyte[]
        ByteArray;

    // -- INQUIRIES

    void Write(
        FILE file
        )
    {
        file.WriteText( Name );
        file.WriteText( Role );
        file.WriteText( Format );
        file.WriteObjectArray( PropertyArray );
        file.WriteScalarArray( ByteArray );
    }

    // -- OPERATIONS

    void Read(
        FILE file
        )
    {
        file.ReadText( Name );
        file.ReadText( Role );
        file.ReadText( Format );
        file.ReadObjectArray( PropertyArray );
        file.ReadScalarArray( ByteArray );
    }
}
