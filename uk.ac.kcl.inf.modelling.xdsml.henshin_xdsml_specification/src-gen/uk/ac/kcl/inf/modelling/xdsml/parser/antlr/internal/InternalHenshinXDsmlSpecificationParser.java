package uk.ac.kcl.inf.modelling.xdsml.parser.antlr.internal;

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import uk.ac.kcl.inf.modelling.xdsml.services.HenshinXDsmlSpecificationGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalHenshinXDsmlSpecificationParser extends AbstractInternalAntlrParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'metamodel'", "'\"'", "'step'"
    };
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_STRING=6;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_SL_COMMENT=8;
    public static final int RULE_INT=5;
    public static final int T__11=11;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int EOF=-1;

    // delegates
    // delegators


        public InternalHenshinXDsmlSpecificationParser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public InternalHenshinXDsmlSpecificationParser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return InternalHenshinXDsmlSpecificationParser.tokenNames; }
    public String getGrammarFileName() { return "InternalHenshinXDsmlSpecification.g"; }



     	private HenshinXDsmlSpecificationGrammarAccess grammarAccess;

        public InternalHenshinXDsmlSpecificationParser(TokenStream input, HenshinXDsmlSpecificationGrammarAccess grammarAccess) {
            this(input);
            this.grammarAccess = grammarAccess;
            registerRules(grammarAccess.getGrammar());
        }

        @Override
        protected String getFirstRuleName() {
        	return "HenshinXDsmlSpecification";
       	}

       	@Override
       	protected HenshinXDsmlSpecificationGrammarAccess getGrammarAccess() {
       		return grammarAccess;
       	}




    // $ANTLR start "entryRuleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:64:1: entryRuleHenshinXDsmlSpecification returns [EObject current=null] : iv_ruleHenshinXDsmlSpecification= ruleHenshinXDsmlSpecification EOF ;
    public final EObject entryRuleHenshinXDsmlSpecification() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleHenshinXDsmlSpecification = null;


        try {
            // InternalHenshinXDsmlSpecification.g:64:66: (iv_ruleHenshinXDsmlSpecification= ruleHenshinXDsmlSpecification EOF )
            // InternalHenshinXDsmlSpecification.g:65:2: iv_ruleHenshinXDsmlSpecification= ruleHenshinXDsmlSpecification EOF
            {
             newCompositeNode(grammarAccess.getHenshinXDsmlSpecificationRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleHenshinXDsmlSpecification=ruleHenshinXDsmlSpecification();

            state._fsp--;

             current =iv_ruleHenshinXDsmlSpecification; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleHenshinXDsmlSpecification"


    // $ANTLR start "ruleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:71:1: ruleHenshinXDsmlSpecification returns [EObject current=null] : (otherlv_0= 'metamodel' otherlv_1= '\"' ( (otherlv_2= RULE_ID ) ) otherlv_3= '\"' (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+ ) ;
    public final EObject ruleHenshinXDsmlSpecification() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_3=null;
        Token otherlv_4=null;
        Token otherlv_5=null;


        	enterRule();

        try {
            // InternalHenshinXDsmlSpecification.g:77:2: ( (otherlv_0= 'metamodel' otherlv_1= '\"' ( (otherlv_2= RULE_ID ) ) otherlv_3= '\"' (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+ ) )
            // InternalHenshinXDsmlSpecification.g:78:2: (otherlv_0= 'metamodel' otherlv_1= '\"' ( (otherlv_2= RULE_ID ) ) otherlv_3= '\"' (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+ )
            {
            // InternalHenshinXDsmlSpecification.g:78:2: (otherlv_0= 'metamodel' otherlv_1= '\"' ( (otherlv_2= RULE_ID ) ) otherlv_3= '\"' (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+ )
            // InternalHenshinXDsmlSpecification.g:79:3: otherlv_0= 'metamodel' otherlv_1= '\"' ( (otherlv_2= RULE_ID ) ) otherlv_3= '\"' (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_1());
            		
            // InternalHenshinXDsmlSpecification.g:87:3: ( (otherlv_2= RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:88:4: (otherlv_2= RULE_ID )
            {
            // InternalHenshinXDsmlSpecification.g:88:4: (otherlv_2= RULE_ID )
            // InternalHenshinXDsmlSpecification.g:89:5: otherlv_2= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getHenshinXDsmlSpecificationRule());
            					}
            				
            otherlv_2=(Token)match(input,RULE_ID,FOLLOW_3); 

            					newLeafNode(otherlv_2, grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageCrossReference_2_0());
            				

            }


            }

            otherlv_3=(Token)match(input,12,FOLLOW_5); 

            			newLeafNode(otherlv_3, grammarAccess.getHenshinXDsmlSpecificationAccess().getQuotationMarkKeyword_3());
            		
            // InternalHenshinXDsmlSpecification.g:104:3: (otherlv_4= 'step' ( (otherlv_5= RULE_ID ) ) )+
            int cnt1=0;
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==13) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:105:4: otherlv_4= 'step' ( (otherlv_5= RULE_ID ) )
            	    {
            	    otherlv_4=(Token)match(input,13,FOLLOW_4); 

            	    				newLeafNode(otherlv_4, grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_4_0());
            	    			
            	    // InternalHenshinXDsmlSpecification.g:109:4: ( (otherlv_5= RULE_ID ) )
            	    // InternalHenshinXDsmlSpecification.g:110:5: (otherlv_5= RULE_ID )
            	    {
            	    // InternalHenshinXDsmlSpecification.g:110:5: (otherlv_5= RULE_ID )
            	    // InternalHenshinXDsmlSpecification.g:111:6: otherlv_5= RULE_ID
            	    {

            	    						if (current==null) {
            	    							current = createModelElement(grammarAccess.getHenshinXDsmlSpecificationRule());
            	    						}
            	    					
            	    otherlv_5=(Token)match(input,RULE_ID,FOLLOW_6); 

            	    						newLeafNode(otherlv_5, grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_4_1_0());
            	    					

            	    }


            	    }


            	    }
            	    break;

            	default :
            	    if ( cnt1 >= 1 ) break loop1;
                        EarlyExitException eee =
                            new EarlyExitException(1, input);
                        throw eee;
                }
                cnt1++;
            } while (true);


            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleHenshinXDsmlSpecification"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000002002L});

}