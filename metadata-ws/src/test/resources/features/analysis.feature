Feature: analysis object

  Scenario: register an analysis successfully
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE for reference sequence
    Then the response code should be 201
    And set the URL to ANALYSIS
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001


  Scenario: update an analysis successfully
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_1
    When I create a study
    Then set the URL to STUDY

    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1 for reference sequence
    Then the response code should be 201
    And set the URL to ANALYSIS
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001
    When I request GET for referenceSequences of ANALYSIS
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items REFERENCE_SEQUENCE_1

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p3",
      "accession": "GCA_000001407.4",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_2
    When I request PATCH ANALYSIS with list REFERENCE_SEQUENCE_2 of referenceSequences
    Then the response code should be 2xx
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001
    When I request GET for referenceSequences of ANALYSIS
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items REFERENCE_SEQUENCE_2


  Scenario Outline: update an analysis with invalid reference sequences list should fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_1
    When I create a study
    Then set the URL to STUDY

    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1 for reference sequence
    Then the response code should be 201
    And set the URL to ANALYSIS
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001
    When I request GET for referenceSequences of ANALYSIS
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items REFERENCE_SEQUENCE_1

    When I request PATCH ANALYSIS with list <list> of referenceSequences
    Then the response code should be 4xx
    And the response should contain field exception with value <exception>

    Examples:
      | list                       | exception                                                                             |
      | NONE                       | uk.ac.ebi.ampt2d.metadata.exceptionhandling.AnalysisWithoutReferenceSequenceException |
      | EMPTY                      | uk.ac.ebi.ampt2d.metadata.exceptionhandling.InvalidReferenceSequenceException         |
      | REFERENCE_SEQUENCE_1,EMPTY | uk.ac.ebi.ampt2d.metadata.exceptionhandling.InvalidReferenceSequenceException         |


  Scenario Outline: register an analysis with invalid reference sequence should fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and <list> for reference sequence
    Then the response code should be 4xx
    And the response should contain field exception with value <exception>

    Examples:
      | list  | exception                                                                             |
      | NONE  | uk.ac.ebi.ampt2d.metadata.exceptionhandling.AnalysisWithoutReferenceSequenceException |
      | EMPTY | uk.ac.ebi.ampt2d.metadata.exceptionhandling.AnalysisWithoutReferenceSequenceException |


  Scenario: delete all of an analysis's reference sequences should fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "BRCA1",
      "patch": "3",
      "accession": "NM_007294.3",
      "type": "SEQUENCE",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "BRCA2",
      "patch": "3",
      "accession": "NM_000059.3",
      "type": "SEQUENCE",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_2
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2 for reference sequence
    Then the response code should be 201
    And set the URL to ANALYSIS
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001
    When I request GET for referenceSequences of ANALYSIS
    Then the response code should be 200
    And the response should contain 2 reference-sequences
    And the href of the referenceSequence of reference-sequences has items REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2

    When I request DELETE for the referenceSequences of REFERENCE_SEQUENCE_1 of the ANALYSIS
    Then the response code should be 2xx

    When I request DELETE for the referenceSequences of REFERENCE_SEQUENCE_2 of the ANALYSIS
    Then the response code should be 4xx
    And the response should contain field exception with value uk.ac.ebi.ampt2d.metadata.exceptionhandling.AnalysisWithoutReferenceSequenceException


  Scenario: register an analysis with multiple gene reference sequences successfully
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "BRCA1",
      "patch": "3",
      "accession": "NM_007294.3",
      "type": "SEQUENCE",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "BRCA2",
      "patch": "3",
      "accession": "NM_000059.3",
      "type": "SEQUENCE",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE_2
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2 for reference sequence
    Then the response code should be 201
    And set the URL to ANALYSIS
    When I request GET with value of ANALYSIS
    Then the response code should be 200
    And the response should contain field accessionVersionId.accession with value EGAA0001
    When I request GET for referenceSequences of ANALYSIS
    Then the response code should be 200
    And the response should contain 2 reference-sequences
    And the href of the referenceSequence of reference-sequences has items REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2


  Scenario Outline: register an analysis with multiple reference sequences should not fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
    <test_reference_sequence_1_json>
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
    <test_reference_sequence_2_json>
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2

    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2 for reference sequence
    Then the response code should be 2xx

    Examples:
      | test_reference_sequence_1_json                                                                                                             | test_reference_sequence_2_json                                                                                                             |
      | "name": "GRCh37","patch": "p2","accession": "GCA_000001407.3","type": "GENOME_ASSEMBLY","taxonomy": "TAXONOMY"      | "name": "GRCh37","patch": "p3","accession": "GCA_000001407.4","type": "GENOME_ASSEMBLY","taxonomy": "TAXONOMY"      |
      | "name": "FOXP2","patch": "nothing important","accession": "NM_014491.3","type": "TRANSCRIPTOME_SHOTGUN_ASSEMBLY","taxonomy": "TAXONOMY" | "name": "BRCA2","patch": "nothing important","accession": "NM_000059.3","type": "TRANSCRIPTOME_SHOTGUN_ASSEMBLY","taxonomy": "TAXONOMY" |
      | "name": "BRCA1","patch": "3","accession": "NM_007294.3","type": "SEQUENCE","taxonomy": "TAXONOMY"                                       | "name": "BRCA2","patch": "nothing important","accession": "NM_000059.3","type": "TRANSCRIPTOME_SHOTGUN_ASSEMBLY","taxonomy": "TAXONOMY" |


  Scenario Outline: register an analysis with multiple reference sequences having different taxonomy should fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    And I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY_HUMAN
    And the response code should be 201
    And I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 10090
    }
    """
    Then set the URL to TAXONOMY_MOUSE
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
    <test_reference_sequence_1_json>
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
    <test_reference_sequence_2_json>
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2

    When I create a study
    Then set the URL to STUDY
    When I create an analysis with STUDY for study and REFERENCE_SEQUENCE_1,REFERENCE_SEQUENCE_2 for reference sequence
    Then the response code should be 4xx
    And the response should contain field exception with value uk.ac.ebi.ampt2d.metadata.exceptionhandling.InvalidReferenceSequenceException
    And the response should contain field message with value Invalid type of reference sequences. When multiple reference sequences are associated with an analysis all of them should point to the same taxonomy

    Examples:
      | test_reference_sequence_1_json                                                                                                                   | test_reference_sequence_2_json                                                                                                                     |
      | "name": "GRCh37","patch": "p2","accession": "GCA_000001407.3", "type":"GENOME_ASSEMBLY","taxonomy": "TAXONOMY_HUMAN"      | "name": "GRCh37","patch": "p3","accession": "GCA_000001407.4","type": "GENOME_ASSEMBLY","taxonomy": "TAXONOMY_MOUSE"       |
      | "name": "FOXP2","patch": "nothing important","accession": "NM_014491.3","type": "TRANSCRIPTOME_SHOTGUN_ASSEMBLY","taxonomy": "TAXONOMY_MOUSE" | "name": "BRCA2","patch": "nothing important",  "accession": "NM_000059.3","type": "TRANSCRIPTOME_SHOTGUN_ASSEMBLY","taxonomy": "TAXONOMY_HUMAN" |

  Scenario Outline: find one analysis by type, technology or platform
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    And I request POST /taxonomies with JSON payload:
     """
     {
       "taxonomyId": 9606
     }
     """
    Then set the URL to TAXONOMY
    And the response code should be 201

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with EGAA0001 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, GWAS for technology, CASE_CONTROL for type and Illumina for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_1
    When I create an analysis with EGAA0002 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, ARRAY for technology, TUMOR for type and PacBio for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_2

    When I request search for the analyses with the parameters: <query>
    Then the response code should be 200
    And the response should contain 1 analyses
    And the href of the analysis of analyses has items <analysis_url>

    Examples:
      | query                       | analysis_url |
      | type=CASE_CONTROL           | ANALYSIS_1   |
      | type=TUMOR                  | ANALYSIS_2   |
      | platform=Illumina           | ANALYSIS_1   |
      | platform=PacBio             | ANALYSIS_2   |
      | platform=pacbio&type=TUMOR  | ANALYSIS_2   |
      | technology=GWAS             | ANALYSIS_1   |
      | technology=ARRAY&type=TUMOR | ANALYSIS_2   |


  Scenario Outline: find zero analysis by type, technology or platform
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with EGAA0001 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, GWAS for technology, CASE_CONTROL for type and Illumina for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_1
    When I create an analysis with EGAA0002 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, ARRAY for technology, TUMOR for type and PacBio for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_2

    When I request search for the analyses with the parameters: <query>
    Then the response code should be 200
    And the response should contain no analysis

    Examples:
      | query               |
      | type=COLLECTION     |
      | platform=nextSeq    |
      | technology=CURATION |


  Scenario Outline: find analysis by invalid type or technology should fail
    Given I set authorization with testoperator having SERVICE_OPERATOR role
    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accession": "GCA_000001407.3",
      "type": "GENOME_ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE
    When I create a study
    Then set the URL to STUDY
    When I create an analysis with EGAA0001 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, GWAS for technology, CASE_CONTROL for type and Illumina for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_1
    When I create an analysis with EGAA0002 for accession, REFERENCE_SEQUENCE for reference sequence, STUDY for study, ARRAY for technology, TUMOR for type and PacBio for platform
    Then the response code should be 201
    And set the URL to ANALYSIS_2

    When I request search for the analyses with the parameters: <query>
    Then the response code should be 4xx

    Examples:
      | query              |
      | type=UNKNOWN       |
      | technology=UNKNOWN |
