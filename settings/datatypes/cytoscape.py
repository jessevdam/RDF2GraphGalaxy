"""
Triple format classes
"""
import re
import data
import logging
from galaxy.datatypes.sniff import *
import dataproviders

log = logging.getLogger(__name__)

class CytoscapeSession( data.Data ):
    """
    The abstract base class for the file format that can contain triples
    """
    edam_format = "format_1"
    file_ext = "cys"

    def sniff( self, filename ):
        """
        Returns false and the user must manually set.
        """
        return False

    def set_peek( self, dataset, is_multi_byte=False ):
        """Set the peek and blurb text"""
        if not dataset.dataset.purged:
            dataset.peek = data.get_file_peek( dataset.file_name, is_multi_byte=is_multi_byte )
            dataset.blurb = 'Cytoscape session file'
        else:
            dataset.peek = 'file does not exist'
            dataset.blurb = 'file purged from disk'

