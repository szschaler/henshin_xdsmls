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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_STRING", "RULE_INT", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'metamodel'", "'step'", "'.'"
    };
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_STRING=5;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_SL_COMMENT=8;
    public static final int RULE_INT=6;
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
    // InternalHenshinXDsmlSpecification.g:62:1: ruleHenshinXDsmlSpecification : ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) ;
    public final void ruleHenshinXDsmlSpecification() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:66:2: ( ( ( rule__HenshinXDsmlSpecification__Group__0 ) ) )
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( rule__HenshinXDsmlSpecification__Group__0 ) )
            {
            // InternalHenshinXDsmlSpecification.g:67:2: ( ( rule__HenshinXDsmlSpecification__Group__0 ) )
            // InternalHenshinXDsmlSpecification.g:68:3: ( rule__HenshinXDsmlSpecification__Group__0 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:69:3: ( rule__HenshinXDsmlSpecification__Group__0 )
            // InternalHenshinXDsmlSpecification.g:69:4: rule__HenshinXDsmlSpecification__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup()); 

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
    // InternalHenshinXDsmlSpecification.g:78:1: entryRuleQualifiedName : ruleQualifiedName EOF ;
    public final void entryRuleQualifiedName() throws RecognitionException {
        try {
            // InternalHenshinXDsmlSpecification.g:79:1: ( ruleQualifiedName EOF )
            // InternalHenshinXDsmlSpecification.g:80:1: ruleQualifiedName EOF
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
    // InternalHenshinXDsmlSpecification.g:87:1: ruleQualifiedName : ( ( rule__QualifiedName__Group__0 ) ) ;
    public final void ruleQualifiedName() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:91:2: ( ( ( rule__QualifiedName__Group__0 ) ) )
            // InternalHenshinXDsmlSpecification.g:92:2: ( ( rule__QualifiedName__Group__0 ) )
            {
            // InternalHenshinXDsmlSpecification.g:92:2: ( ( rule__QualifiedName__Group__0 ) )
            // InternalHenshinXDsmlSpecification.g:93:3: ( rule__QualifiedName__Group__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup()); 
            // InternalHenshinXDsmlSpecification.g:94:3: ( rule__QualifiedName__Group__0 )
            // InternalHenshinXDsmlSpecification.g:94:4: rule__QualifiedName__Group__0
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
    // InternalHenshinXDsmlSpecification.g:102:1: rule__HenshinXDsmlSpecification__Group__0 : rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 ;
    public final void rule__HenshinXDsmlSpecification__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:106:1: ( rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1 )
            // InternalHenshinXDsmlSpecification.g:107:2: rule__HenshinXDsmlSpecification__Group__0__Impl rule__HenshinXDsmlSpecification__Group__1
            {
            pushFollow(FOLLOW_3);
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
    // InternalHenshinXDsmlSpecification.g:114:1: rule__HenshinXDsmlSpecification__Group__0__Impl : ( 'metamodel' ) ;
    public final void rule__HenshinXDsmlSpecification__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:118:1: ( ( 'metamodel' ) )
            // InternalHenshinXDsmlSpecification.g:119:1: ( 'metamodel' )
            {
            // InternalHenshinXDsmlSpecification.g:119:1: ( 'metamodel' )
            // InternalHenshinXDsmlSpecification.g:120:2: 'metamodel'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelKeyword_0()); 

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
    // InternalHenshinXDsmlSpecification.g:129:1: rule__HenshinXDsmlSpecification__Group__1 : rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2 ;
    public final void rule__HenshinXDsmlSpecification__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:133:1: ( rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2 )
            // InternalHenshinXDsmlSpecification.g:134:2: rule__HenshinXDsmlSpecification__Group__1__Impl rule__HenshinXDsmlSpecification__Group__2
            {
            pushFollow(FOLLOW_4);
            rule__HenshinXDsmlSpecification__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__2();

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
    // InternalHenshinXDsmlSpecification.g:141:1: rule__HenshinXDsmlSpecification__Group__1__Impl : ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:145:1: ( ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 ) ) )
            // InternalHenshinXDsmlSpecification.g:146:1: ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 ) )
            {
            // InternalHenshinXDsmlSpecification.g:146:1: ( ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 ) )
            // InternalHenshinXDsmlSpecification.g:147:2: ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelAssignment_1()); 
            // InternalHenshinXDsmlSpecification.g:148:2: ( rule__HenshinXDsmlSpecification__MetamodelAssignment_1 )
            // InternalHenshinXDsmlSpecification.g:148:3: rule__HenshinXDsmlSpecification__MetamodelAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__MetamodelAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelAssignment_1()); 

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


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__2"
    // InternalHenshinXDsmlSpecification.g:156:1: rule__HenshinXDsmlSpecification__Group__2 : rule__HenshinXDsmlSpecification__Group__2__Impl ;
    public final void rule__HenshinXDsmlSpecification__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:160:1: ( rule__HenshinXDsmlSpecification__Group__2__Impl )
            // InternalHenshinXDsmlSpecification.g:161:2: rule__HenshinXDsmlSpecification__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group__2__Impl();

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__2"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group__2__Impl"
    // InternalHenshinXDsmlSpecification.g:167:1: rule__HenshinXDsmlSpecification__Group__2__Impl : ( ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:171:1: ( ( ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* ) ) )
            // InternalHenshinXDsmlSpecification.g:172:1: ( ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* ) )
            {
            // InternalHenshinXDsmlSpecification.g:172:1: ( ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* ) )
            // InternalHenshinXDsmlSpecification.g:173:2: ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) ) ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* )
            {
            // InternalHenshinXDsmlSpecification.g:173:2: ( ( rule__HenshinXDsmlSpecification__Group_2__0 ) )
            // InternalHenshinXDsmlSpecification.g:174:3: ( rule__HenshinXDsmlSpecification__Group_2__0 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_2()); 
            // InternalHenshinXDsmlSpecification.g:175:3: ( rule__HenshinXDsmlSpecification__Group_2__0 )
            // InternalHenshinXDsmlSpecification.g:175:4: rule__HenshinXDsmlSpecification__Group_2__0
            {
            pushFollow(FOLLOW_5);
            rule__HenshinXDsmlSpecification__Group_2__0();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_2()); 

            }

            // InternalHenshinXDsmlSpecification.g:178:2: ( ( rule__HenshinXDsmlSpecification__Group_2__0 )* )
            // InternalHenshinXDsmlSpecification.g:179:3: ( rule__HenshinXDsmlSpecification__Group_2__0 )*
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_2()); 
            // InternalHenshinXDsmlSpecification.g:180:3: ( rule__HenshinXDsmlSpecification__Group_2__0 )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==12) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:180:4: rule__HenshinXDsmlSpecification__Group_2__0
            	    {
            	    pushFollow(FOLLOW_5);
            	    rule__HenshinXDsmlSpecification__Group_2__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getGroup_2()); 

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group__2__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_2__0"
    // InternalHenshinXDsmlSpecification.g:190:1: rule__HenshinXDsmlSpecification__Group_2__0 : rule__HenshinXDsmlSpecification__Group_2__0__Impl rule__HenshinXDsmlSpecification__Group_2__1 ;
    public final void rule__HenshinXDsmlSpecification__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:194:1: ( rule__HenshinXDsmlSpecification__Group_2__0__Impl rule__HenshinXDsmlSpecification__Group_2__1 )
            // InternalHenshinXDsmlSpecification.g:195:2: rule__HenshinXDsmlSpecification__Group_2__0__Impl rule__HenshinXDsmlSpecification__Group_2__1
            {
            pushFollow(FOLLOW_6);
            rule__HenshinXDsmlSpecification__Group_2__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group_2__1();

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_2__0"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_2__0__Impl"
    // InternalHenshinXDsmlSpecification.g:202:1: rule__HenshinXDsmlSpecification__Group_2__0__Impl : ( 'step' ) ;
    public final void rule__HenshinXDsmlSpecification__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:206:1: ( ( 'step' ) )
            // InternalHenshinXDsmlSpecification.g:207:1: ( 'step' )
            {
            // InternalHenshinXDsmlSpecification.g:207:1: ( 'step' )
            // InternalHenshinXDsmlSpecification.g:208:2: 'step'
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_2_0()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getStepKeyword_2_0()); 

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_2__0__Impl"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_2__1"
    // InternalHenshinXDsmlSpecification.g:217:1: rule__HenshinXDsmlSpecification__Group_2__1 : rule__HenshinXDsmlSpecification__Group_2__1__Impl ;
    public final void rule__HenshinXDsmlSpecification__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:221:1: ( rule__HenshinXDsmlSpecification__Group_2__1__Impl )
            // InternalHenshinXDsmlSpecification.g:222:2: rule__HenshinXDsmlSpecification__Group_2__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__Group_2__1__Impl();

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_2__1"


    // $ANTLR start "rule__HenshinXDsmlSpecification__Group_2__1__Impl"
    // InternalHenshinXDsmlSpecification.g:228:1: rule__HenshinXDsmlSpecification__Group_2__1__Impl : ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 ) ) ;
    public final void rule__HenshinXDsmlSpecification__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:232:1: ( ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 ) ) )
            // InternalHenshinXDsmlSpecification.g:233:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 ) )
            {
            // InternalHenshinXDsmlSpecification.g:233:1: ( ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 ) )
            // InternalHenshinXDsmlSpecification.g:234:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_2_1()); 
            // InternalHenshinXDsmlSpecification.g:235:2: ( rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 )
            // InternalHenshinXDsmlSpecification.g:235:3: rule__HenshinXDsmlSpecification__UnitsAssignment_2_1
            {
            pushFollow(FOLLOW_2);
            rule__HenshinXDsmlSpecification__UnitsAssignment_2_1();

            state._fsp--;


            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsAssignment_2_1()); 

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__Group_2__1__Impl"


    // $ANTLR start "rule__QualifiedName__Group__0"
    // InternalHenshinXDsmlSpecification.g:244:1: rule__QualifiedName__Group__0 : rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 ;
    public final void rule__QualifiedName__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:248:1: ( rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1 )
            // InternalHenshinXDsmlSpecification.g:249:2: rule__QualifiedName__Group__0__Impl rule__QualifiedName__Group__1
            {
            pushFollow(FOLLOW_7);
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
    // InternalHenshinXDsmlSpecification.g:256:1: rule__QualifiedName__Group__0__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:260:1: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:261:1: ( RULE_ID )
            {
            // InternalHenshinXDsmlSpecification.g:261:1: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:262:2: RULE_ID
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
    // InternalHenshinXDsmlSpecification.g:271:1: rule__QualifiedName__Group__1 : rule__QualifiedName__Group__1__Impl ;
    public final void rule__QualifiedName__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:275:1: ( rule__QualifiedName__Group__1__Impl )
            // InternalHenshinXDsmlSpecification.g:276:2: rule__QualifiedName__Group__1__Impl
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
    // InternalHenshinXDsmlSpecification.g:282:1: rule__QualifiedName__Group__1__Impl : ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) ) ;
    public final void rule__QualifiedName__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:286:1: ( ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) ) )
            // InternalHenshinXDsmlSpecification.g:287:1: ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) )
            {
            // InternalHenshinXDsmlSpecification.g:287:1: ( ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* ) )
            // InternalHenshinXDsmlSpecification.g:288:2: ( ( rule__QualifiedName__Group_1__0 ) ) ( ( rule__QualifiedName__Group_1__0 )* )
            {
            // InternalHenshinXDsmlSpecification.g:288:2: ( ( rule__QualifiedName__Group_1__0 ) )
            // InternalHenshinXDsmlSpecification.g:289:3: ( rule__QualifiedName__Group_1__0 )
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalHenshinXDsmlSpecification.g:290:3: ( rule__QualifiedName__Group_1__0 )
            // InternalHenshinXDsmlSpecification.g:290:4: rule__QualifiedName__Group_1__0
            {
            pushFollow(FOLLOW_8);
            rule__QualifiedName__Group_1__0();

            state._fsp--;


            }

             after(grammarAccess.getQualifiedNameAccess().getGroup_1()); 

            }

            // InternalHenshinXDsmlSpecification.g:293:2: ( ( rule__QualifiedName__Group_1__0 )* )
            // InternalHenshinXDsmlSpecification.g:294:3: ( rule__QualifiedName__Group_1__0 )*
            {
             before(grammarAccess.getQualifiedNameAccess().getGroup_1()); 
            // InternalHenshinXDsmlSpecification.g:295:3: ( rule__QualifiedName__Group_1__0 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==13) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalHenshinXDsmlSpecification.g:295:4: rule__QualifiedName__Group_1__0
            	    {
            	    pushFollow(FOLLOW_8);
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
    // InternalHenshinXDsmlSpecification.g:305:1: rule__QualifiedName__Group_1__0 : rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 ;
    public final void rule__QualifiedName__Group_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:309:1: ( rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1 )
            // InternalHenshinXDsmlSpecification.g:310:2: rule__QualifiedName__Group_1__0__Impl rule__QualifiedName__Group_1__1
            {
            pushFollow(FOLLOW_6);
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
    // InternalHenshinXDsmlSpecification.g:317:1: rule__QualifiedName__Group_1__0__Impl : ( '.' ) ;
    public final void rule__QualifiedName__Group_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:321:1: ( ( '.' ) )
            // InternalHenshinXDsmlSpecification.g:322:1: ( '.' )
            {
            // InternalHenshinXDsmlSpecification.g:322:1: ( '.' )
            // InternalHenshinXDsmlSpecification.g:323:2: '.'
            {
             before(grammarAccess.getQualifiedNameAccess().getFullStopKeyword_1_0()); 
            match(input,13,FOLLOW_2); 
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
    // InternalHenshinXDsmlSpecification.g:332:1: rule__QualifiedName__Group_1__1 : rule__QualifiedName__Group_1__1__Impl ;
    public final void rule__QualifiedName__Group_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:336:1: ( rule__QualifiedName__Group_1__1__Impl )
            // InternalHenshinXDsmlSpecification.g:337:2: rule__QualifiedName__Group_1__1__Impl
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
    // InternalHenshinXDsmlSpecification.g:343:1: rule__QualifiedName__Group_1__1__Impl : ( RULE_ID ) ;
    public final void rule__QualifiedName__Group_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:347:1: ( ( RULE_ID ) )
            // InternalHenshinXDsmlSpecification.g:348:1: ( RULE_ID )
            {
            // InternalHenshinXDsmlSpecification.g:348:1: ( RULE_ID )
            // InternalHenshinXDsmlSpecification.g:349:2: RULE_ID
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


    // $ANTLR start "rule__HenshinXDsmlSpecification__MetamodelAssignment_1"
    // InternalHenshinXDsmlSpecification.g:359:1: rule__HenshinXDsmlSpecification__MetamodelAssignment_1 : ( ( RULE_STRING ) ) ;
    public final void rule__HenshinXDsmlSpecification__MetamodelAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:363:1: ( ( ( RULE_STRING ) ) )
            // InternalHenshinXDsmlSpecification.g:364:2: ( ( RULE_STRING ) )
            {
            // InternalHenshinXDsmlSpecification.g:364:2: ( ( RULE_STRING ) )
            // InternalHenshinXDsmlSpecification.g:365:3: ( RULE_STRING )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageCrossReference_1_0()); 
            // InternalHenshinXDsmlSpecification.g:366:3: ( RULE_STRING )
            // InternalHenshinXDsmlSpecification.g:367:4: RULE_STRING
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageSTRINGTerminalRuleCall_1_0_1()); 
            match(input,RULE_STRING,FOLLOW_2); 
             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageSTRINGTerminalRuleCall_1_0_1()); 

            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getMetamodelEPackageCrossReference_1_0()); 

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__MetamodelAssignment_1"


    // $ANTLR start "rule__HenshinXDsmlSpecification__UnitsAssignment_2_1"
    // InternalHenshinXDsmlSpecification.g:378:1: rule__HenshinXDsmlSpecification__UnitsAssignment_2_1 : ( ( ruleQualifiedName ) ) ;
    public final void rule__HenshinXDsmlSpecification__UnitsAssignment_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalHenshinXDsmlSpecification.g:382:1: ( ( ( ruleQualifiedName ) ) )
            // InternalHenshinXDsmlSpecification.g:383:2: ( ( ruleQualifiedName ) )
            {
            // InternalHenshinXDsmlSpecification.g:383:2: ( ( ruleQualifiedName ) )
            // InternalHenshinXDsmlSpecification.g:384:3: ( ruleQualifiedName )
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_2_1_0()); 
            // InternalHenshinXDsmlSpecification.g:385:3: ( ruleQualifiedName )
            // InternalHenshinXDsmlSpecification.g:386:4: ruleQualifiedName
            {
             before(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitQualifiedNameParserRuleCall_2_1_0_1()); 
            pushFollow(FOLLOW_2);
            ruleQualifiedName();

            state._fsp--;

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitQualifiedNameParserRuleCall_2_1_0_1()); 

            }

             after(grammarAccess.getHenshinXDsmlSpecificationAccess().getUnitsUnitCrossReference_2_1_0()); 

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
    // $ANTLR end "rule__HenshinXDsmlSpecification__UnitsAssignment_2_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000001002L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000002002L});

}