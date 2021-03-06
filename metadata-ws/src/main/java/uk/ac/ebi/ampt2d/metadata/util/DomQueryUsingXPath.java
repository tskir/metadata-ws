/*
 *
 * Copyright 2019 EMBL - European Bioinformatics Institute
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package uk.ac.ebi.ampt2d.metadata.util;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.StringReader;

public class DomQueryUsingXPath {

    private final XPath xPath = XPathFactory.newInstance().newXPath();

    private Document document;

    public DomQueryUsingXPath(String xml) throws Exception {
        DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        this.document = builder.parse(new InputSource(new StringReader(xml)));
    }

    public String findInDom(String expression) throws XPathExpressionException {
        return (String) xPath.evaluate(expression, document, XPathConstants.STRING);
    }

    public boolean isExpressionExists(String expression) throws XPathExpressionException {
        return (boolean) xPath.evaluate("boolean(" + expression + ")", document, XPathConstants.BOOLEAN);
    }
}
