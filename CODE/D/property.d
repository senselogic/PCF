module pcf.property;

// -- IMPORTS

import pcf.stream;

// -- TYPES

class PROPERTY
{
    // -- ATTRIBUTES

    string
        Name,
        Value,
        Format;

    // -- INQUIRIES

    void Write(
        STREAM stream
        )
    {
        stream.WriteText( Name );
        stream.WriteText( Value );
        stream.WriteText( Format );
    }

    // -- OPERATIONS

    void Read(
        STREAM stream
        )
    {
        stream.ReadText( Name );
        stream.ReadText( Value );
        stream.ReadText( Format );
    }
}
