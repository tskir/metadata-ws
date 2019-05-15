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

package uk.ac.ebi.ampt2d.metadata.importer.objectImporters;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import uk.ac.ebi.ampt2d.metadata.importer.MetadataImporterMainApplication;
import uk.ac.ebi.ampt2d.metadata.importer.ObjectsImporter;
import uk.ac.ebi.ampt2d.metadata.persistence.entities.Study;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

@RunWith(SpringRunner.class)
@TestPropertySource(value = "classpath:application.properties", properties = {"import.source=API"})
@ContextConfiguration(classes = {MetadataImporterMainApplication.class})
public class SraObjectsImporterAPITest {

    @Autowired
    private ObjectsImporter sraObjectImporter;

    @Test
    public void importStudy() throws Exception {
        Set<String> studyAccessions = new HashSet<>();
        studyAccessions.add("ERP000054");
        studyAccessions.add("SRP000717");
        List<Study> studies = sraObjectImporter.importStudy(studyAccessions);
        assertNotNull(studies);
        assertEquals(2, studies.size());

        studyAccessions.clear();
        studyAccessions.add("SRP000392");
        studies = sraObjectImporter.importStudy(studyAccessions);
        assertNotNull(studies);
        assertEquals(1, studies.size());
        assertEquals(1, studies.get(0).getPublications().size());

        studyAccessions.clear();
        studyAccessions.add("SRP000118");
        studies = sraObjectImporter.importStudy(studyAccessions);
        assertNotNull(studies);
        assertEquals(1, studies.size());
        assertEquals(1, studies.get(0).getResources().size());
    }

}