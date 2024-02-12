-- Program designed to return EURO/'Country X' currentcy exchange rate.  Currently returns EURO/BGN currency exchange rate

declare
p xmlparser.parser;
doc xmldom.DOMDocument;
doc_xml clob;
url1 varchar2(100) := 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml';
nl xmldom.DOMNodeList;
n xmldom.DOMNode;
n2 xmldom.DOMNode;
len1 number;
len2 number;
e xmldom.DOMElement;
nnm xmldom.DOMNamedNodeMap;
attrname varchar2(100);
attrval varchar2(100);

begin
    p := xmlparser.newParser;
-- set some characteristics
    select url_contents into doc_xml from test_xml;
--    xmlparser.parseClob(p, doc_xml);
    xmlparser.parse(p, url1);
-- get document
    doc := xmlparser.getDocument(p);
 
-- get all elements
   nl := xmldom.getElementsByTagName(doc, '*');
   len1 := xmldom.getLength(nl);

-- loop through elements
    for j in 0..len1-1 loop
        n := xmldom.item(nl, j);
        e := xmldom.makeElement(n);
      -- get all attributes of element
        nnm := xmldom.getAttributes(n);

        if (xmldom.isNull(nnm) = FALSE) then
            len2 := xmldom.getLength(nnm);

        -- loop through attributes
        for i in 0..len2-1 loop
            n := xmldom.item(nnm, i);
            attrname := xmldom.getNodeName(n);
            attrval := xmldom.getNodeValue(n);
            if attrname = 'currency' and attrval = 'BGN' then
                n2 := xmldom.item(nnm, i+1);
                dbms_output.put_line(xmldom.getNodeValue(n2));
            end if;
        end loop;
     end if;
   end loop;
    
exception

when xmldom.INDEX_SIZE_ERR then
   raise_application_error(-20120, 'Index Size error');

when xmldom.DOMSTRING_SIZE_ERR then
   raise_application_error(-20120, 'String Size error');

when xmldom.HIERARCHY_REQUEST_ERR then
   raise_application_error(-20120, 'Hierarchy request error');

when xmldom.WRONG_DOCUMENT_ERR then
   raise_application_error(-20120, 'Wrong doc error');

when xmldom.INVALID_CHARACTER_ERR then
   raise_application_error(-20120, 'Invalid Char error');

when xmldom.NO_DATA_ALLOWED_ERR then
   raise_application_error(-20120, 'Nod data allowed error');

when xmldom.NO_MODIFICATION_ALLOWED_ERR then
   raise_application_error(-20120, 'No mod allowed error');

when xmldom.NOT_FOUND_ERR then
   raise_application_error(-20120, 'Not found error');

when xmldom.NOT_SUPPORTED_ERR then
   raise_application_error(-20120, 'Not supported error');

when xmldom.INUSE_ATTRIBUTE_ERR then
   raise_application_error(-20120, 'In use attr error');

end;
