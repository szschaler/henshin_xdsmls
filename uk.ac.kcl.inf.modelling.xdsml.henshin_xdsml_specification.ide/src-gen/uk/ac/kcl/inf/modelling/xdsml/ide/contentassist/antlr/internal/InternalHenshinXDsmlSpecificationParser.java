package uk.ac.kcl.inf.modelling.xdsml.ide.contentassist.antlr.internal;

import java.io.InputStream;
import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.DFA;
import uk.ac.kcl.inf.modelling.xdsml.services.HenshinXDsmlSpecificationGrammarAccess;



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalHenshinXDsmlSpecificationParser extends AbstractInternalContentAssistParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'step'", "'.'"
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

    	public void setGrammarAccess(HenshinXDsmlSpecificationGrammarAccess grammarAccess) {
    		this.grammarAccess = grammarAccess;
    	}

    	@Override
    	protected Grammar getGrammar() {
    		return grammarAccess.getGrammar();
    	}

    	@Override
    	protected String getValueForTokenName(String tokenName) {
    		return tokenName;
    	}



    // $ANTLR start "entryRuleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:53:1: entryRuleHenshinXDsmlSpecification : ruleHenshinXDsmlSpecification EOF ;
    public final void entryRuleHenshinXDsmlSpecification() throws RecognitionException {
        try {
            // InternalHenshinXDsmlSpecification.g:54:1: ( ruleHenshinXDsmlSpecification EOF )
            // InternalHenshinXDsmlSpecification.g:55:1: ruleHenshinXDsmlSpecification EOF
            {
             before(grammarAccess.getHenshinXDsmlSpecificationRule()); 
            pushFollow(FOLLOW_1);
            ruleHenshinXDsmlSpecification();

            state._fsp--;

             after(grammarAccess.getHenshinXDsmlSpecificationRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleHenshinXDsmlSpecification"


    // $ANTLR start "ruleHenshinXDsmlSpecification"
    // InternalHenshinXDsmlSpecification.g:62:1: ruleHenshinXDsmlSpecification : ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group__0 )* ) ) ;
    public final void ruleHenshinXDsmlSpecification() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:66:2: ( ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group__0 )* ) ) )
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group__0 )* ) )
            {
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group__0 )* ) )
            // InternalHenshinXDsmlSpecification.g:68:3: ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group__0 )* )
            {
            // InternalHenshinXDsmlSpecification.g:68:3: ( ( rule__HenshinXDsmlSpecification__Group__0 ) )
            // InternalHenshinXDsmlSpecification.g:69:4: ( rule__HenshinXDsmlSpecification__Group__0 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:70:4: ( rule__HenshinXDsmlSpecification__Group__0 )
            // InternalHenshinXDsmlSpecification.g:70:5: rule__HenshinXDsmlSpecification__Group__0
            {
            pushFollow(FOLLOW_3);
            rule__HenshinXDsmlSpecification__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 

            }

            // InternalHenshinXDsmlSpecification.g:73:3: ( ( rule__HenshinXDsmlSpecification__Group__0 )* )
            // InternalHenshinXDsmlSpecification.g:74:4: ( rule__HenshinXDsmlSpecification__Group__0 )*
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:75:4: ( rule__HenshinXDsmlSpecification__Group__0 )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==11) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:75:5: rule__HenshinXDsmlSpecification__Group__0
            	    {
            	    pushFollow(FOLLOW_3);
            	    rule__HenshinXDsmlSpecification__Group__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 

            }


            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleHenshinXDsmlSpecification"


    // $ANTLR start "entryRuleQualifiedName"
    // InternalHenshinXDsmlSpecification.g:85:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalHenshinXDsmlSpecification.g:86:1: ( ruleQualifiedName EOF )
            // InternalHenshinXDsmlSpecification.g:87:1: ruleQualifiedName EOF
            {
             before(grammarAccess.getQualifiedNameRule()); 
            pushFollow(FOLLOW_1);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getQualifiedNameRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleQualifiedName"


    // $ANTLR start "ruleQualifiedName"
    // InternalHenshinXDsmlSpecification.g:94:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:98:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalHenshinXDsmlSpecification.g:99:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalHenshinXDsmlSpecification.g:99:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalHenshinXDsmlSpecification.g:100:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:101:3: ( rule__QualifiedName__Group__0 )
            // InternalHenshinXDsmlSpecification.g:101:4: rule__QualifiedName__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getQualifiedNameAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleQualifiedName"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__0"
    // InternalHenshinXDsmlSpecification.g:109:1: rule__HenshinXDsmlSpecification__Group__0 : rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 ;
    public final void rule__HenshinXDsmlSpecification__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:113:1: ( rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 )
            // InternalHenshinXDsmlSpecification.g:114:2: rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1
            {
            pushFollow(FOLLOW_4);
            rule__HenshinXDsmlSpecification__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__0"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__0__Impl"
    // InternalHenshinXDsmlSpecification.g:121:1: rule__HenshinXDsmlSpecification__Group__0__Impl : ( 'step' ) ;
    public final void rule__HenshinXDsmlSpecification__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:125:1: ( ( 'step' ) )
            // InternalHenshinXDsmlSpecification.g:126:1: ( 'step' )
            {
            // InternalHenshinXDsmlSpecification.g:126:1: ( 'step' )
            // InternalHenshinXDsmlSpecification.g:127:2: 'step'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__0__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__1"
    // InternalHenshinXDsmlSpecification.g:136:1: rule__HenshinXDsmlSpecification__Group__1 : rule__HenshinXDsmlSpecification__Group__1__Impl ;
    public final void rule__HenshinXDsmlSpecification__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:140:1: ( rule__HenshinXDsmlSpecification__Group__1__Impl )
            // InternalHenshinXDsmlSpecification.g:141:2: rule__HenshinXDsmlSpecification__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__1"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__1__Impl"
    // InternalHenshinXDsmlSpecification.g:147:1: rule__HenshinXDsmlSpecification__Group__1__Impl : ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:151:1: ( ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 ) ) )
            // InternalHenshinXDsmlSpecification.g:152:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 ) )
            {
            // InternalHenshinXDsmlSpecification.g:152:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 ) )
            // InternalHenshinXDsmlSpecification.g:153:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_1()); 
            // InternalHenshinXDsmlSpecification.g:154:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_1 )
            // InternalHenshinXDsmlSpecification.g:154:3: rule__HenshinXDsmlSpecification__UnitsAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__UnitsAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__1__Impl"


    // $ANTLR start "rule__QualifiedName__Group__0"
    // InternalHenshinXDsmlSpecification.g:163:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:167:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalHenshinXDsmlSpecification.g:168:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_5);
            rule__QualifiedName__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__0"


    // $ANTLR start "rule__QualifiedName__Group__0__Impl"
    // InternalHenshinXDsmlSpecification.g:175:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:179:1: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:180:1: ( RULE_ID )
            {
            // InternalHenshinXDsmlSpecification.g:180:1: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:181:2: RULE_ID
            {
             before(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__0__Impl"


    // $ANTLR start "rule__QualifiedName__Group__1"
    // InternalHenshinXDsmlSpecification.g:190:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:194:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalHenshinXDsmlSpecification.g:195:2: rule__QualifiedName__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__1"


    // $ANTLR start "rule__QualifiedName__Group__1__Impl"
    // InternalHenshinXDsmlSpecification.g:201:1: rule__QualifiedName__Group__1__Impl : ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:205:1: ( ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) ) )
            // InternalHenshinXDsmlSpecification.g:206:1: ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) )
            {
            // InternalHenshinXDsmlSpecification.g:206:1: ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalHenshinXDsmlSpecification.g:207:2: ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalHenshinXDsmlSpecification.g:207:2: ( ( rule__QualifiedName__Group_1__0 ) )
            // InternalHenshinXDsmlSpecification.g:208:3: ( rule__QualifiedName__Group_1__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalHenshinXDsmlSpecification.g:209:3: ( rule__QualifiedName__Group_1__0 )
            // InternalHenshinXDsmlSpecification.g:209:4: rule__QualifiedName__Group_1__0
            {
            pushFollow(FOLLOW_6);
            rule__QualifiedName__Group_1__0();

            state._fsp--;


            }

             after(grammarAccess.getQualifiedNameAccess().getGroup_1()); 

            }

            // InternalHenshinXDsmlSpecification.g:212:2: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalHenshinXDsmlSpecification.g:213:3: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalHenshinXDsmlSpecification.g:214:3: ( rule__QualifiedName__Group_1__0 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==12) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:214:4: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_6);
            	    rule__QualifiedName__Group_1__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

             after(grammarAccess.getQualifiedNameAccess().getGroup_1()); 

            }


            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group__1__Impl"


    // $ANTLR start "rule__QualifiedName__Group_1__0"
    // InternalHenshinXDsmlSpecification.g:224:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:228:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalHenshinXDsmlSpecification.g:229:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
            {
            pushFollow(FOLLOW_4);
            rule__QualifiedName__Group_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group_1__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__0"


    // $ANTLR start "rule__QualifiedName__Group_1__0__Impl"
    // InternalHenshinXDsmlSpecification.g:236:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:240:1: ( ( '.' ) )
            // InternalHenshinXDsmlSpecification.g:241:1: ( '.' )
            {
            // InternalHenshinXDsmlSpecification.g:241:1: ( '.' )
            // InternalHenshinXDsmlSpecification.g:242:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__0__Impl"


    // $ANTLR start "rule__QualifiedName__Group_1__1"
    // InternalHenshinXDsmlSpecification.g:251:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:255:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalHenshinXDsmlSpecification.g:256:2: rule__QualifiedName__Group_1__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__QualifiedName__Group_1__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__1"


    // $ANTLR start "rule__QualifiedName__Group_1__1__Impl"
    // InternalHenshinXDsmlSpecification.g:262:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:266:1: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:267:1: ( RULE_ID )
            {
            // InternalHenshinXDsmlSpecification.g:267:1: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:268:2: RULE_ID
            {
             before(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getQualifiedNameAccess().getIDTerminalRuleCall_1_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__QualifiedName__Group_1__1__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__UnitsAssignment_1"
    // InternalHenshinXDsmlSpecification.g:278:1: rule__HenshinXDsmlSpecification__UnitsAssignment_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__HenshinXDsmlSpecification__UnitsAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:282:1: ( ( ( ruleQualifiedName ) ) )
            // InternalHenshinXDsmlSpecification.g:283:2: ( ( ruleQualifiedName ) )
            {
            // InternalHenshinXDsmlSpecification.g:283:2: ( ( ruleQualifiedName ) )
            // InternalHenshinXDsmlSpecification.g:284:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_1_0()); 
            // InternalHenshinXDsmlSpecification.g:285:3: ( ruleQualifiedName )
            // InternalHenshinXDsmlSpecification.g:286:4: ruleQualifiedName
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitQualifiedNameParserRuleCall_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitQualifiedNameParserRuleCall_1_0_1()); 

            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__HenshinXDsmlSpecification__UnitsAssignment_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000802L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000001002L});

}